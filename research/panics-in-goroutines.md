---
date: 2021-02-26T13:41
---

# Panics in goroutines

If we have two goroutines running, and one panics, will the other goroutine
notice, or will it just stop?

Because when you panic, all deferred function calls are still executed.

## Where is this applicable

For the `cmd` project in Wharf we start up a bunch of pods. If one fails and
panics, we don't want the program to hault, we still want the other goroutines
to try and cancel what they were doing by killing those (potentionally
successful) pods.

Imagine the following pods:

1. manager pod with wharf/cmd program
2. pod for stage "deploy", step "web"
3. pod for stage "deploy", step "api"
4. pod for stage "deploy", step "db"

If pod 2 panics, then pod 3 and 4 should be killed before the pod 1 errors out.

Wharf must always clean up after itself.

## Q: Will deferred functions be called?

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	go printAfter(3 * time.Second)
	go panicAfter(2 * time.Second)

	time.Sleep(4 * time.Second)
}

func printAfter(d time.Duration) {
	defer func() {
		fmt.Println("printAfter: deferred print")
	}()
	time.Sleep(d)
	fmt.Println("printAfter: final print")
}

func panicAfter(d time.Duration) {
	defer func() {
		fmt.Println("panicAfter: deferred print")
	}()
	time.Sleep(d)
	panic("panicAfter: panic")
}
```

```sh
$ go run .
panicAfter: deferred print
panic: panicAfter: panic

goroutine 7 [running]:
main.panicAfter(0x77359400)
        /home/kalle/dev/go-playground/goroutines-errors/main.go:30 +0x69
created by main.main
        /home/kalle/dev/go-playground/goroutines-errors/main.go:10 +0x60
exit status 2
```

A: No. The `printAfter` deferred function was not called.

## Q: What if the parent goroutine panics?

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	go printAfter(3 * time.Second)
	go panicAfter(2 * time.Second)

	time.Sleep(1 * time.Second)
	panic("main")
}

func printAfter(d time.Duration) {
	defer func() {
		fmt.Println("printAfter: deferred print")
	}()
	time.Sleep(d)
	fmt.Println("printAfter: final print")
}

func panicAfter(d time.Duration) {
	defer func() {
		fmt.Println("panicAfter: deferred print")
	}()
	time.Sleep(d)
	panic("panicAfter: panic")
}
```

```sh
$ go run .
panic: main

goroutine 1 [running]:
main.main()
        /home/kalle/dev/go-playground/goroutines-errors/main.go:12 +0x89
exit status 2
```

A: Still a no.

## References

- https://stackoverflow.com/a/46917360/3163818
