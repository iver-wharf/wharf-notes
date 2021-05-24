---
date: 2021-02-19T10:35
---

# Events in Go

Go does not support events like how C# does. It turns out it's actually quite
tedious to add events to Go, especially due to the lack of generics in Go.

## The issues with channels

Go channels does not support "fanout" strategies, making it difficult to work
with for events.

- If the channel is closed -> panic.
- If no one is listening to the events -> deadlock.
- If multiple are listening to the same channel, only 1 gets the message.

## The issues with replicating events

- Lack of generics in Go, so we have to rely on casting `interface{}` types such
  as:

  ```go
  type Event struct {
      Type   string
      Object interface{}
  }
  ```

## Sample implementation

Could use [k8s.io/apimachinery/pkg/watch](https://pkg.go.dev/k8s.io/apimachinery/pkg/watch)
here, though it's not well documented and [the repo on GitHub](https://github.com/kubernetes/apimachinery)
advices against using it as they do not guarantee a stable API.

What you could do is just a really simple implementation instead:

```go
type ContainerState int
const (
    ContainerStarted ContainerState = iota
    ContainerReady
    ContainerStopped
)

type ContainerStateChange {
    OldState ContainerState
    State    ContainerState
    UID      string
    Name     string
}

type ContainerStateWatcher interface {
    ContainerStateChanged(event ContainerStateChange)
}

type PodEvents struct {
    containerState []ContainerStateWatcher
}

func (events *podEvents) OnContainerState(event ContainerStateChange) {
    for _, watcher := range events.containerState {
        watcher.ContainerStateChanged(event)
    }
}

func (events *podEvents) WatchContainerState(watcher ContainerStateWatcher) {
    events.containerState = append(events.containerState, watcher)
}
```

Unregistering is the tricky part, as Go does not hash interfaces like C# does,
nor do they support a nice and fast solution to just "remove a list item",
which is understandable.

## Letting listeners unregister

A more sophisticated solution that is able to unregister could be to store the
watcher ID and use that in a map:

```go
type PodEvents struct {
    nextWatcherId int
    containerState *map[int]ContainerStateWatcher
}

func (events *podEvents) OnStateChanged(event ContainerStateChange) {
    if events.containerState == nil {
        return
    }
    for _, watcher := range events.containerState {
        watcher.ContainerStateChanged(event)
    }
}

type Unwatcher interface {
    Unwatch()
}

type containerStateUnregistrar struct {
    id        int
    podEvents *PodEvents
}

func (u containerStateUnwatcher) Unwatch() {
    delete(u.podEvents.containerState, u.id)
}

func (events *podEvents) WatchContainerState(watcher ContainerStateWatcher) Unwatcher {
    // throw in some sync.Mutex.Lock/Unlock here if we want to support concurrency
    events.nextWatcherId++
    id := events.nextWatcherId
    events[id] = watcher
    return containerStateUnwatcher { id, events }
}
```

This also supports registering the same watcher instance multiple times and
then receiving the same event multiple times.

Keep in mind, that this whole registering and unregistering code need to be
duplicated for every event. As Go lacks generics, this is the way it has to be
done, without traversing into the space of reflection, which I [Kalle]
personally try to avoid at all times as it goes against the conventions and
strengths that the language is trying to enforce.

## Alternative: Don't use events!

For the above sample, something like this might be more appropriate:

```go
interface ContainerReadyWaiter {
    // Wait waits for the next container to be ready and returns true when it
    // has, or returns false if there are no more containers to wait for.
    Wait() bool
    // Container returns the container you have been Wait()'ing for, or an error
    // if the waiting failed in some way. Returns (nil, nil) if Wait() has not
    // yet been called once.
    Container() (Container, error)
}
```

Instead of listening for events to know when a container is ready, this interface
could be used to traverse the containers and waiting until they are done before
proceeding with the next, without even loosing the call stack such if you
would've implemented this via goroutines.

Using it would involve something like:

```go
var waiter ContainerReadyWaiter

for waiter.Wait() {
    c, err := waiter.Container()
    if err != nil {
        return fmt.Errorf("wait to work with container: %w", err)
    }

    SetupLogStreaming(c)

    if cmds, ok := commandsPerContainer[c.Name]; ok {
        RunCommandsInContainer(c, cmds)
    }
}
```

Solution is less flexible. Though it could arguably quite easily be changed to
`ContainerStatusWaiter` to return whenever a status has been changed.
