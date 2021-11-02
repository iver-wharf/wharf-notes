---
date: 2021-11-02T10:15
tags:
  - meeting
---

# 2021-11-02 wharf-cmd-provisioning

Discussing the proposal from [[wharf-cmd-provisioning]]# with coworkers.

## Attendence

Alexander (@Alexamakans),
Björn (@bjornosterman),
Fredrik (@fredx30),
Kalle (@jilleJr),
Mikael (@Pikabanga)

## Notes

Idea 1 is the most promising. @jilleJr will write an RFC based on that.

All `wharf-cmd-*` components are expected to live inside the `wharf-cmd` repo.

Potential other names for `wharf-cmd-aggregator`:

- `wharf-cmd-injector`
- `wharf-cmd-forwarder`

Build can be marked as done first after all artifacts has been uploaded to
`wharf-api`. Another argument for using async API instead of request/response,
as with async it is easier to coordinate this condition.

Was missing the "cancel build" flow from the design, but that can be implemented
via the `wharf-api` &rarr; `wharf-cmd-provisioner` communication.

### Async API

Let's go with gRPC. It does induce a requirement on HTTP/2, but that's OK.

### Horizontal scaling

- `wharf-cmd-provisioner` can be replicated without issues.

- `wharf-cmd-aggregator` can not simply be replicated, as that would induce
  double-duty. Leading idea is to have them as a Kubernetes StatefulSet and let
  them have their own set of dedicated `wharf-cmd-worker`'s.
  
  For example, given there are 3 aggregators, then:
  
  - `wharf-cmd-aggregator-0` handles workers where their $ID \bmod 3 = 0$
  - `wharf-cmd-aggregator-1` handles workers where their $ID \bmod 3 = 1$
  - `wharf-cmd-aggregator-2` handles workers where their $ID \bmod 3 = 2$

- `wharf-api` cannot be scaled, but that's due to existing limitations such as
  the Server Sent Events (SSE) for logs not being distributed among multiple
  `wharf-api` pods.

### Conclusions

Not any adjustments to idea 1 are needed. Plan looks good.

As this was a high level design, we need lower level details in the RFC, such as
a sample gRPC definition.
