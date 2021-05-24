---
date: 2021-02-04T13:49
tags: 
  - stub
---

# Fallback strategy

Given the shell is set to `bash` in a `container` step, and that the runner has
`bash` installed then it should be able to use the local one.

If the list of strategies is as follows:

- Local
- Docker
- Kubernetes

Then if it is possible to run locally, then it should try that.

With this we would need to be able to specify for the "local" runner that we have
that as a dependency.

## Example step type definition

This would then be defined in the #[[wharf-definition-repo]].

```yaml
# local container definition

inputs:
  image:
    type: string
    description: Docker image name and tag. Example: "alpine:latest"
  cmds:
    type: array
    itemType: string
    description: Commands to run (in sequence) in the container.
    
# Here comes the dependency requirements stuff
prerequisites:
  - type: program
    program:
      name: docker

steps:
  - type: cmd
    cmd: |
      docker -d --rm "${image}"

```
