---
date: 2021-02-05T13:32
tags: 
  - stub
---

# Wharf CLI plugins

By using the Hashicorp *Go Plugin System over RPC[^go-plugin]* each build target
environment needs only to be included in the `$PATH`.

## Sample interface

This is not final!

```go
type Flag struct {
    Name         string
    ShortName    string
    Description  string
    IsArgument   bool
    IsRequired   bool
    DefaultValue string
    // Type Type // some enum of types, ex file, existingFile, etc. 
    //           // just for potential future autocompletion
}

type Arguments = map[string]string // flag name: argument value

type Build struct {
    BuildID    int
    Step       wharf.Step
    Definition wharf.Definition
}

// Builder is the interface for the wharf command to talk to the builder plugin
type Builder interface {
    CanBuild(build Build, args Arguments) bool
    Build(build Build, args Arguments)
    Flags() []Flag
    Version() string
}
```

## Sample use case: -\-help

```sh
$ wharf build kubernetes --help
Usage: wharf build kubernetes

Wharf flags:
  -h, --help                        Show this help.
  --version                         Show the version of the 'kubernetes' plugin.
  --build                           Set the build ID.
  -v, --verbose                     Enable verbose logging.
  
Plugin flags (kubernetes):
  --kubeconfig="~/.kube/config"     Path to the kubeconfig to use.
```

In the background, the Wharf CLI did this:

1. Spin up the `kubernetes` plugin, for example named `wharf-build-kubernetes`
2. Connect to it via RPC
3. Ask for its flags via `Builder.Flags()`
4. Combine with some Wharf flags, such as the `--help` and `--version` flags
5. Print output.
6. Exit.

## Sample use case: Building

```sh
$ wharf build kubernetes --build 2355
I0302 13:57.215113  wharf                   build.go:23] Starting build: 2355
I0302 13:57.215113  wharf                   build.go:23] Running step: build/web
I0302 13:57.215113  wharf-build-kubernetes  main.go:23] Checking connection with Kubernetes cluster...
I0302 13:57.215113  wharf-build-kubernetes  main.go:23] Creating pod 'wharf-docker-2355'
I0302 13:57.215113  wharf-build-kubernetes  main.go:23] Waiting for pod to initialize...
```

In the background, the Wharf CLI did this:

1. Read `.wharf-ci.yml`
2. Log `Starting build: 2355`
3. Log `Running step: build/web`
4. Spin up the `kubernetes` plugin, for example named `wharf-build-kubernetes`
5. Connect to it via RPC
6. Pass it the `build/web` step to build via `Builder.Build(...)`
7. Wait for it to complete
8. Continue to the next step...

[^go-plugin]: Hashicorp, *Go Plugin System over RPC*, <https://github.com/hashicorp/go-plugin>
