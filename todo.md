---
date: 2021-02-05T10:33
tags: 
  - stub
---

# Todo

- [ ] tools/wharf-project/cmd flow.

    - [ ] Build environment plugin structure (bare metal, k8s, docker, etc)

- [ ] Turn providers into plugins, even for the frontend

  This work is started over at [[wharf-provider-apis-as-plugins]]#
  and [[hide-providers-behind-api]]#.

- [ ] Cloning repos

- [ ] Substituting variables in Go

    - [ ] ... in build definition (`.wharf-ci.yml`)
    - [ ] ... in YAML (ex: `deploy/ingress.yaml`)
    - [ ] ... in text files (ex: `Dockerfile`)
    - [ ] ... in parameters (ex: `docker.tag: ${GIT_TAG}`)

- [ ] Redesign `.wharf-ci.yml` to be more

    - easily understood for newcomers (less magic strings, ex `environments`)
    - easily parsable by automatic parsers, by have more structured format
    - consistent param names (camelCasing vs kebab-casing)
    - consistent param formats (comma separated vs lists)
    - Maybe even toss out the idea of Stages/Steps, and just have recursive Jobs?
