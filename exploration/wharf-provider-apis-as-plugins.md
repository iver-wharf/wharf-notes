---
date: 2021-02-15T10:14
tags: 
  - stub
---

# Wharf provider APIs as plugins

## How it is currently

We host the following APIs:

| Path                | Description
| ----                | -----------
| /api                | Talks to the database as a basic CRUD for projects, groups, builds, etc.
| /import/github      | Driver for talking to GitHub and then forwarding that to the main API.
| /import/gitlab      | Same as the GitHub provider API, but for GitLab.
| /import/azuredevops | Same as the GitHub provider API, but for Azure DevOps/TFS.

This makes it very tedious to work with, and when working locally you have to
have a reverse proxy (ex: Traefik, Nginx) setup as the frontend currently assumes
that there's only 1 host.

This also means that you HAVE to setup a wide range of reverse proxy routes, and
add more as soon as you add more provider APIs.

## How it can be

The main API uses some kind of plugin system
(ex: <https://github.com/hashicorp/go-plugin>) to talk to the different
"providers" directly on the same system.

In practice, the main API could add the following endpoint:

```sh
POST /api/import/:providerName
```

```json
// HTTP request body
{
    "domain": "github.com",
    "group": "iver-wharf",
    "project": "api",
    "token": "foobar"
}
```

And then it resolves the provider API name from the `:providerName` path query
and talks to the appropriate provider plugin.

> Important when designing this that we take in the
> [[security-considerations-when-importing]]#. The current flow for importing
> a project is foolish, to say the least, when it comes to security.

## Pros

- One single OpenAPI specification for the entire API, instead of having one at
  `/api/swagger/doc.json`, one at `/import/github/swagger/doc.json`, etc.

- Providers don't need to be hosted separately, which is increadibly overkill
  right now as they only contain some special logic how the HTTP calls should be
  structured.
  
  - This means that it'll be easier to run Wharf locally without Docker.

- Less duplication of code as we can move some of the parsing, auth, or other
  details into the main API.
  
- We still avoid circular dependencies as a plugins architecture means we'll be
  doing dependency inversion.

- If we use Hashicorp's `go-plugin` package then users can still write custom
  providers in any language they choose as `go-plugin` supports communicating
  via gRPC.

- We can have proper two-way communication between the main API and the plugins,
  meaning we don't have to rely on systems like RabbitMQ.
  
  - A message bus dependecy is overkill. The communication Wharf does with the
    providers does not require the "fanout" features that RabbitMQ provides.

## Cons

- If we use Hashicorp's `go-plugin`:

  - gRPC has its downsides when it comes to backward compatability. Compared to
    REST, gRPC requires much more careful management on the versioning as
    fields cannot be haphazardly added or removed.
    
    If we're following SemVer 2.0.0 correctly, then just versioning each endpoint
    under v1, v2, v3... should be sufficient. Consider how to comply with
    [[grpc-backward-compatability]]# in the plugin API protocols.

