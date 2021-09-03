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

- Generalizing import flow means we can deduplicate a lot of code from
  wharf-web, such as regarding auth flows.
  
- Less code duplication overall between wharf-api, wharf-web and the
  wharf-provider-... projects as we can move most business logic into wharf-api.
  
- Only 1 Swagger/OpenAPI specification, instead of wharf-api and each
  wharf-provider-... having their own.
  
- Users of wharf-api only need to provide essential data, such as the ID of the
  project to import, instead of having to also feed in things like the URLs of
  the remote providers needed in a project refresh, as that data is already
  known in the DB. See [[refreshing-project]]# for a concrete example.
  
- Easier to extend the data flows and wharf-api<->wharf-provider-... integration
  without building on further code rot.
  
- Fewer entrypoints/attack surfaces to worry about security.

### Drawbacks

- Take a lot of time to design and develop.

- Makes it harder to have custom implementations and endpoint behaviors per
  provider.
  
- Forces the wharf-api <-> wharf-provider API layers to be highly rigid.
  Introducing changes will need updates in multiple repos and lots of backward
  compatibilities. Though that's the case in today's solution as well.
  
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
  
- Regen access tokens for every request to the wharf-provider-...

- ~~Let each provider get their own DB schema to store the tokens for themselves.
  They would need something like a 1-N mapping from credentials to Wharf project
  IDs.~~
  
  > Do we really want to add dependency on the DB from the providers?
  >
  > If wharf-api stored the credentials in the DB serialized as JSON then the
  > providers would control the format, and the DB remains hidden behind the
  > wharf-api.
  >
  > Letting more services depend on the DB means more places to worry about
  > sustaining connection, DB migrations, resolving connection issues, switching
  > which DB to use, etc.

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

