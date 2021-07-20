---
date: 2021-07-20
---

# Hide providers behind API

Currently the user and web interface talks directly to the provider APIs.

This document explores how the providers should be redesigned, while the
[[wharf-provider-apis-as-plugins]]# document explores how they should be plugged
into a Wharf installation, compared to now.

## Motive

### Benefits

- Simpler to develop
- Easier to add custom code per provider

### Drawbacks

- Must edit the wharf-web when making changes to any of the provider auth flows.

- Lots of code is spread out and duplicated across wharf-api, wharf-web and the
  wharf-provider-... projects
  
- Multiple Swagger documentations to keep track of. Each provider has their own
  implementation, and the different provider APIs are not identical to each
  other but instead differ a little bit here and there.
  
- User must provide most data in their requests to the provider as we try to
  keep roundtrips low.
  
- Development hell in the long run as it's difficult to adjust the flows and
  extend them for other code flows without adding further code rot.
  
## Redesign

To better the situation, a redesign is in order.

## Considerations for redesign

- Wharf-api must via dependency-inversion talk to a predefined provider API 
  "standard" that the wharf-provider-github, among others, must comply with,
  so that we avoid any circular dependencies.

- Stay with REST so that the provider APIs can still use the
  [wharf-api-client-go](https://github.com/iver-wharf/wharf-api-client-go)
  library for when the providers want to initiate communication, such as when
  they want to start a new build because of a newly added PR.
  
## Ideas for redesign

- Import procedure should be completely revamped. Instead of providing
  credentials on each import, it should instead be:
  
  - Set up credentials beforehand

  - Import project using one of the existing credentials (for a given provider)

  - Provider API should provide a list of project candidates to import, and
    wharf-api should mark those that have already been imported with a boolean
    flag.
    
- Leave the data-collection over to the wharf-api. The user should not have to
  provide lots of data just because we're lazy when the wharf-api could easily
  figure out all the data via the DB.

## Proposed provider endpoints

Base URL is subject for change, or even variable on a per-provider basis.

- Fetching data from known project.

- Fetching list of candidate projects to import.

- Heartbeat to verify that the provider is still available. To be used in
  metrics and possibly notify the user in wharf-web when picking a provider to
  import via.

- Get Git URL to be used in builds. Cannot be a static field in the database as
  some integrations, such as GitHub Apps, require usage of tokens with 1h
  lifetime.

- Wildcard endpoint to be forwarded, such as for authentication or webhooks.
  *Unsure about this though, as they will not be documented.*

