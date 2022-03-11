---
date: 2022-03-11T09:48
---

# 2022-03-11 wharf-cmd built-in vars

Attendance: @jilleJr, @Alexamakans

## Synopsis

How to design specifying built-in variables when running wharf-cmd locally.

Based on discussion from https://github.com/iver-wharf/wharf-cmd/issues/55

Want to allow specifying config options as well for wharf-cmd.

- Should this be placed in the same file as the built-in variables, or in a different file?
- Should we allow vars to be declared recursively in dirs above the `.wharf-ci.yml` file?
- Should we configs to be declared recursively in dirs above the `.wharf-ci.yml` file?

## Problem with configs in repo

Allowing `.wharf-conf.yml` in the same dir as `.wharf-ci.yml` file or above could
lead to some weird security holes. Such as the edge case of the `.wharf-conf.yml`
changes which context from the kubeconfig to use and then accidentally leak that
information.

It's too much control for a repo to have.

## Problem with vars in repo

None apparent.

## Problem with merging config and vars

Could merge them, such as:

```yaml
# my-git-repo/.wharf-conf.yml
runner: docker

vars:
  CHART_REPO: http://harbor.local/library
```

Though as the config shouldn't be used inside the repo, this means either:

- wharf-cmd errors on configs used where not allowed. Though this is bad UX as it's not statically clear.

- we only allow `.wharf-vars.yml` inside the repo, and allow vars to also be set inside `.wharf-conf.yml`. Though also bad UX as there are so many files to keep track of. 2 is slightly high, but 3 is way too many.

## Feature: wharf-conf.yaml

Had a debate about the difference between `.wharf-conf.yml`, `.wharf-vars.yml`,
and `.wharf-ci.yml`.

We agree on allowing `.wharf-vars.yml` recursively in the dir tree above
`.wharf-ci.yml`. It seems like a good idea to allow dir-based built-in vars.

## Feature: Presets

Idea of having multiple runner presets that are easy to pick from via the CLI.

Example:

```yaml
# .wharf-conf.yml
runner: my-prod-kubernetes # Overridable with CLI arg?
runners:
  my-prod-kubernetes:
    type: kubernetes
    kubeconfig:
      context: prod-cluster

  my-dev-kubernetes:
    type: kubernetes
    kubeconfig:
      context: dev-cluster
```

```console
$ wharf-cmd run --runner my-dev-kubernetes
```

## Finalized idea

`.wharf-conf.yml` only lives inside config dirs (`~/.config` & `/etc/`).

`.wharf-ci.yml` only lives inside repo.

`.wharf-vars.yml` can live at either:

- recursively up the dir tree, including inside the repo.
- inside config dirs

The configs and variables are merged before starting the wharf build.

## Conclusions

- `.wharf-vars.yml` needs a new name. It's difficult to pronounce.

- We have the 3 different file types, but the config one only lives inside the
  config dirs.
