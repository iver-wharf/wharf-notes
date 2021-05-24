---
date: 2021-02-04T13:42
tags: 
  - stub
---

# wharf-definition repo

A repository containing templates of how to run a Wharf step.

## Motive

1. Split up logic of how to run locally and how to run in kubernetes.

2. Enable users to fork ours to extend it with more steps.

3. In a .wharf-ci.yml file, you should be able to specify the definition repo.
   Such as:
   
   ```yaml
   # ==vvvv== This part ==vvvv==
   definitions:
     git:
       repo: https://gitlab.local/wharf-project/definitons.git
   # ==^^^^== This part ==^^^^==
   
   environments:
     prod:
       cluster: # ...
   
   build:
     web:
       docker:
         # ...
   ```

## Sample structure 1

- /
  - container/
    - local.yaml
    - kubernetes.yaml
  - kubectl/
    - local.yaml
    - kubernetes.ymal
  - go/
    - local.yaml
    - kubernetes.yaml

## Sample structure 2

- /
  - local/
    - container.yaml
    - kubectl.yaml
    - dotnet.yaml
    - go.yaml
  - kubernetes/
    - container.yaml
    - kubectl.yaml
    - dotnet.yaml
    - go.yaml
