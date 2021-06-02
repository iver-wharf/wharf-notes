---
date: 2021-02-18T14:01
tags:
  - mr/cmd/9
---

# Orchestrating k8s build from cmd

> This originates from discussions in merge request on the cmd repo in our
> internal GitLab instance, !9.

How do we in a clean and composable way run pods in k8s based on a
`.wharf-ci.yml` file?

## Issues

- Kubernetes does not send an event of when a container has become "Ready".
  Only when a container is "Ready" can you feed it with commands (equivalent to
  `kubectl exec`) and read logs off it (equivalent to `kubectl logs`)

- Go channels does not support "fanout" strategies, making it difficult to work
  with for events.

  - If the channel is closed -> panic.
  - If no one is listening to the events -> deadlock.
  - If multiple are listening to the same channel, only 1 gets the message.

- We need to keep the call stacks as best as we can so that panics and errors can
  be properly propagated. Splitting up into goroutines also means that we have to
  aggregate our results and errors when stuff goes wrong. Extra code that perhaps
  can be mitigated by not relying too heavily on goroutines for events and loops.

## Brainstorming

These are just ideas, nothing final.

### Brainstorm: Do we really need to send events

We're using events to get notified when all containers are ready. But would a
`podClient.WaitForContainerReady` method be more appropriate?

Event-driven code is a nice strategy, but Go does not have great support for
events with its lack of generics and lack of fan-out channels. We need a lot of
"plumbing"/infrastructure set up to introduce this parigim that is arguably quite
badly supported in Go.

This is explored more in-depth over at [[events-in-go]]#.

### Brainstorm: How do we access repo files with variable substitution

Where does variable parsing come in the picture?

- Should that reside in it's own package?
- Stream the "var-sub" resources instead of storing everything in RAM?

This deserves its own zettel to explore, but for now, let's assume that the list
of variable values have been calculated for us somehow and that there is some
function that does raw variable substitution on strings for us; for the sake of
argument, let's call that the `util.SubstituteVariables` function.

## Abstraction layers

> Going from higher level to lower level.

1. Orchestrate Wharf build

   - In: Wharf build definition, step manager interface
   - Start stage
   - Wait until they're finished
   - Start next list of parallel jobs
   - Run next stage, if there is another one queued

2. Orchestrate Wharf stage

   - In: List of steps to run in parallel, log watcher factory, step manager
     factory

   - Tasks:
     - Create step managers from each step definition
     - Feed managers with log watcher factory
     - Tell all managers to start working
     - Wait until all are finished and removed

3. Step k8s pod manager : step manager interface

   - In: Step definition
   - Tasks:
     - Translate step definition to pod definition
     - Create pod
     - Listen to events
       - Container ready: hook up log handlers
       - Container ready: run commands in it
       - Container shut down: close any log handlers
     - Teardown: Delete pod via k8s API, if not already deleted

4. Easy pod facade

   - In: Pod manifest (docker image, entrypoints, volumes)
   - Methods:
     - creating pod
     - deleting pod
     - setup event watchers
     - run command in container
     - list containers and their statuses
   - Tasks:
     - Polyfill missing events, such as when container is "Ready"

     - Abstract away "init containers" vs "app containers" as the same, just have
       a boolean flag to distinguish them, but this boolean should not even need
       to be used.
       
       > The only difference between an init container and regular containers are
       > when they're executed. Their names must even be unique across all
       > containers, including init containers.
       >
       > "The name of each app and init container in a Pod must be unique; a
       > validation error is thrown for any container sharing a name with
       > another."[^init-containers]

     - Teardown: Delete pod via k8s API

5. Events sending

   - Tasks:
     - Allow registering of watchers
     - Allow sending messages
     - Messages are distributed to all watchers
     - Not listening -> missing out on events

## Infrastructure

```go
package builder

type Logger {
    Logln(line string)
}

type LoggerFactory {
    NewLogger(source string) Logger
}

type consoleLoggerFactory struct {
    out io.Writer
}

type consoleLogger struct {
    out io.Writer
    source string
}

func (log consoleLogger) Logln(line string) {
    // maybe would be nice with some ANSI colors here
    fmt.Fprintf(log.out, "%s: %s\n", c.source, line)
}
```

## 1. Orchestrate Wharf build

```go
package builder

type StepResult struct {
    Name     string
    Type     string
    Success  bool
    Duration time.Duration
}

type StageResult struct {
    Name     string
    Success  bool
    Duration time.Duration
    Steps    []StepResult
}

type Result struct {
    Environment string
    Success     bool
    Duration    time.Duration
    Stages      []StageResult
}

type Builder interface {
    Build(def wharfyml.BuildDefinition) (Result, error)
}

type builder struct {
    run    StageRunner
    logFac LoggerFactory
}

func New(run StageRunner, logFac LoggerFactory) Builder {}

func (b Builder) Build(def wharfyml.BuildDefinition) (Result, error) {
    // This is just pseudo-code.
    stageResults := []
    buildTimer.Start()

    foreach stage
        res, err := stageRunner.Run(stage)
        if err
            return err
        stageResults.Add(res)

    buildTimer.Stop()
    return Result{stageResults}
}
```

## 2. Orchestrate Wharf stage

```go
package builder

type StageRunner interface {
    Run() (StageResult, error)
}

func NewStageRunner(run StepRunner, logFac LoggerFactory) StageRunner {}

func (r StepRunner) Run() (StageResult, error) {
    // This is just pseudo-code.
    stepResults = []
    stageTimer.Start()
    
    waitGroup.Add(len(steps))
    cancelCh := make(ch interface{})
    foreach step
        go r.runStep(step, waitGroup, cancelCh)
    waitGroup.Wait()
    
    stageTimer.Start()
    
    err := aggregateErrors()
    if err
        return err
    else
        return StageResult{stepResults}
}

func (r StageRunner) runStep(step wharfyaml.Step, wg sync.WaitGroup, cancelCh ch interface{}) {
    // This is just pseudo-code.
    defer handlePanic() // this should send panic through cancelCh
    
    res, err := r.stepRunner.Run(step)
    recordResult(res, err)
    wg.Done()
}
```

## 3. Step k8s pod manager : step manager interface

```go
package builder

type StepRunner interface {
    Run() (StepResult, error)
}
```

## 4. Easy pod facade

```go
type PodFacade interface {
}
```

## ~~5. Events sending~~

Event sending might not be that good of an option. I've created a separate page
[[events-in-go]]# that explores this option. The solution is pretty bloated.

[^init-containers]: "Init Containers | Kubernetes" <https://kubernetes.io/docs/concepts/workloads/pods/init-containers/#detailed-behavior>
