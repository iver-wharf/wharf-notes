---
date: 2021-11-08T14:15
---

# wharf-cmd-provisioner API

Based on the brainstorming from #[[wharf-cmd-provisioning]].

TODO:
- wharf-cmd-aggregator -> wharf-cmd-watchdog
- polling taken from wharf-api and put into wharf-cmd-watchdog

## Types

```go
package response

type Status uint
const (
    // "Pending" in k8s
    StatusQueued Status = 0

    // "ContainerCreating" in k8s
    StatusScheduling Status = 0

    // "Running" in k8s
    StatusRunning Status = 1

    // "Failed" or "Error" in k8s
    StatusFailed Status = 2

    // "Completed" in k8s
    StatusCompleted Status = 3
)

type Worker struct {
    // Unique per provisioner, e.g k8s pod GUID or container ID
    WorkerID string

    // Can be null, such as for local builds not started via wharf-api
    BuildRef *uint

    StatusID Status

    Started time.Time
    Stopped time.Time
}
```

```go
package request

type Worker struct {
    // ???
}
```

## Endpoints

### `GET /api/worker`

List all workers.

Request body: *none*\
Response body: `[]response.Worker`

| Query parameter | Type      | Description              |
|-----------------|-----------|--------------------------|
| `buildRef`      | `string?` | Filter on Wharf build ID |
| `statusId`      | `uint`    | Filter on status by ID   |

### `GET /api/worker/:workerId`

Get a specific worker by ID.

Request body: *none*\
Response body: `response.Worker`

| Path parameter | Type     | Description   |
|----------------|----------|---------------|
| `:workerId`    | `string` | ID of worker. |

### `POST /api/worker`

Start up a new worker

Request body: `request.Worker`\
Response body: `response.Worker`

### `DELETE /api/worker/:workerId`

Request body: *none*\
Response body: "204 No Content"

| Path parameter | Type     | Description   |
|----------------|----------|---------------|
| `:workerId`    | `string` | ID of worker. |
