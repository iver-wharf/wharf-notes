---
date: 2022-02-17T07:19
tags: 
  - stub
---

# Todo

High level look at what needs to be done in Wharf. This belongs better as GitHub
issues, but these things needs to be designed/architected first.

Ordering of the bulletpoints are an approximation of the order of which we
should tackle them, with the first one to tackle at the top.

## In progress

- Add authentication to Wharf (OpenID Connect, Azure AD): [RFC-0013](https://iver-wharf.github.io/rfcs/published/0013-authentication)

- Make `wharf-cmd` feature-par with our Jenkins implementation.

## Planned

- Turn providers into plugins, even for the frontend. (explored in [[wharf-provider-apis-as-plugins]]# & [[hide-providers-behind-api]]#)

- Add RBAC support to Wharf's auth implementation.

- Make step types in `.wharf-ci.yml` dynamic. (explored in [[wharf-definition-repo]]# & [[fallback-strategy]]#)

- Redesign `.wharf-ci.yml` to be more:

  - easily understood for newcomers (less magic strings, ex `environments`)
  - easily parsable by automatic parsers, by have more structured format
  - consistent param names (camelCasing vs kebab-casing)
  - consistent param formats (comma separated vs lists)
  - replace steps/stages with recursive jobs and configurable parallel vs sequential.
  - new variable syntax (see [[different-variable-syntaxes]]#)
  - possibly just name it `.wharf.yml` instead, as it's both CI and CD.
  - abstraction over container steps, and not locked in to Kubernetes.

