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

- Add streaming component for streaming logs and build updates. Would be good
  to offload this into a separate component so the wharf-api can be replicated
  separately, as currently if you have two replicas of the wharf-api then you
  will get half the logs streamed due to the load balancing.

- Add notification component for sending emails. (<https://github.com/iver-wharf/iver-wharf.github.io/issues/33>)

- Consider adding CLA (contributor license agreement) before merging first PR
  from outside collaborator. Read more: [[cla-considerations]]

- Figure out a good plugin system for wharf-cmd to allow external
  implementations of step runners. Needs to be language agnostic.

- Figure out a better plugin system for wharf provisioners so they don't need
  their own pods. They are so seldomly used so embedding them inside
  wharf-api's container is a much better solution. Needs to be language agnostic.
