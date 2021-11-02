---
date: 2021-11-02T13:00
tags:
  - meeting
---

# 2021-11-02 wharf-cmd handover

What's the state of the `wharf-cmd` repo? (<https://github.com/iver-wharf/wharf-cmd>)

Let's invite Ewelina who worked on this a good while ago, but has since been
transferred to a different project.

## Attendence

Ewelina (@iverestefans),
Fredrik (@fredx30),
Kalle (@jilleJr),
Piotr (@Grimwind)

## Notes

Should merge `estefans/stepCleanUp` into `master`, even though it's not finished.
Not much gain in keeping them as separate branches. This will involve introducing
some developers into a new component with a lot of code, so easier to have it
all in a shared place (i.e. the `master` branch).

### Branches to keep

- `master` *(duh!)*
- `estefans/stepCleanUp`

### Branches to delete

The following branches are subject for deletion as they contains outdated
proof-of-concepts and are no longer relevant. Nothing extensive will be lost.

- `estefans/dockerKaniko`
- `estefans/events`

### What's left on TODO

- Missing variable substitution/replacing logic here and there.

- Missing step type container implementation in `podspec.go`, among other places

- Book up meeting with today's Wharf devs, preferrably with a whiteboard, so we
  can go through in detail what's already there, how it works, and what's left.
  @jilleJr will book this meeting.

- Focus on `pkg/core/kubernetes/podclient.go`, as a lot of core high level pod
  management logic lives in here.
