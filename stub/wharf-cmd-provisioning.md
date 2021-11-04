---
date: 2021-10-28T14:52
---

# wharf-cmd provisioning

## Design goals

We want to replace Jenkins. How do we provision the wharf-cmd in a way that meets
the following requirements:

- Lightweight implementation in wharf-api. Should mostly just be a "CI_URL" switch
  so that we still can have Jenkins as a fallback.

- Network only goes towards the build environment (where we run builds).
  No network connections from the build environment to the Wharf hosting
  environment should be made, just to make network ops/management simpler and
  easier to secure with the fewer firewall rules.

- No circular nor bi-directional dependencies/API access.

- Possibility to check for "missing builds" for when builds started, but the
  Jenkins slave pod is gone and never reported itself as "done". Wharf-api still
  thinks they are "Scheduling" or "Running" forever.
  
- Start build with same webhook signature as used in Jenkins webhook, to allow
  switching back to Jeknins as a fallback. Can be deprecated from v1 and only
  needed until wharf-cmd is feature-equivalent to our Jenkins solution.
  
- wharf-api should not know about Kubernetes.

- wharf-cmd should work with OCI-compatible containers (Kubernetes, Docker socket, Podman socket, containerd/runc, etc.)

- Need async API to read logs. Pushing each log line, even if batched, in
  separate HTTP requests is bad. Can be used to read status updates and
  artifacts as well.

## Unresolved questions

- Thoughts on reading artifacts via async API (e.g gRPC)?

- Horizontal scaling possibilities? May need multiple aggregators for
  high availability. How to make sure they don't do double duty?
  
  - Ex: Add Kubernetes Service object in front of workers, to automatically
    load balance the aggregators via round-robin when opening new connection.
    
- Better ways to figure out "missing builds"?

- How to queue up jobs? Inside wharf-api or inside wharf-cmd-provisioner?

## Current

![diagram of current](static/wharf-cmd-provisioning-current.svg)

Pros:

- It works (although buggy and the heavy Jenkins dependency)

Cons:

- Circular dependency, even if it's "just the logs".
- Build environment requires network access to the hosting environment.
- Business logic is written in Groovy/Jenkinsfile's instead of Go.

## Idea 1

![diagram of 1st future alternative](static/wharf-cmd-provisioning-future-1.svg)

Pros:

- Minimal code in the wharf-api. Keeps wharf-api as mostly a CRUD API.

- Reuses wharf-api endpoints such as `POST /api/build/:buildId/artifact`

- SRP through the roof! wharf-cmd-provisioner only creates and lists pods,
  wharf-cmd-aggregator only relays build data (logs, artifacts, and build status) to the wharf-api.

Cons:

- wharf-api need to poll wharf-cmd-provisioner for build lists to figure out missing builds

Use cases:

- wharf-api:

  - tell wharf-cmd-provisioner to start build.
  - periodically poll wharf-cmd-provisioner for active builds, to figure out missing builds

- wharf-cmd-provisioner:

  - spin up wharf-cmd-worker pods (with Git clone init containers)
  - can check (on-demand) for active builds, so wharf-api can diff for missing builds

- wharf-cmd-aggregator:

  - stream logs, artifacts, status from wharf-cmd-workers to wharf-api

- wharf-cmd-workers:

  - spin up pods for build steps from .wharf-ci.yml
  - set up caching & workspaces via PVCs for build pods
  - store logs, artifacts, status changes locally, until it's killed
  - provide async API (websockets? GRPC?) for reading logs, artifacts, status updates

## Idea 2

> ==Note:== This idea has been dismissed in meeting [[2021-11-02-wharf-cmd-provisioning]].

![diagram of 2nd future alternative](static/wharf-cmd-provisioning-future-2.svg)

Pros:

- Less code in the wharf-api
- Fewer components (no split between wharf-cmd-provisioning & wharf-cmd-aggregator)

Cons:

- Custom code in wharf-api for loading artifacts, logs, build status updates from wharf-cmd-manager.
- Custom procedure just for loading logs, compared to current solution where Logstash inserted that for us
- wharf-cmd-manager acts just like a proxy/relay for build data. Why not just go directly to the source(s)?

Use cases:

- wharf-api:

  - tell wharf-cmd-manager to start build.
  - periodically poll wharf-cmd-manager for active builds, to figure out missing builds
  - stream logs, artifacts, status from wharf-cmd-manager to database

- wharf-cmd-manager:

  - spin up wharf-cmd-worker pods (with Git clone init containers)
  - can check (on-demand) for active builds, so wharf-api can diff for missing builds
  - stream logs, artifacts, status from wharf-cmd-workers to database

- wharf-cmd-workers:

  - spin up pods for build steps from .wharf-ci.yml
  - set up caching & workspaces via PVCs for build pods
  - store logs, artifacts, status changes locally, until it's killed
  - provide async API (websockets? GRPC?) for reading logs, artifacts, status updates
