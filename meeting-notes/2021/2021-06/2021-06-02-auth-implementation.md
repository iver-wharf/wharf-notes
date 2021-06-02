---
date: 2021-06-02T09:00
tags:
  - stub
---

# 2021-06-02 Auth implementation

Need to investigate which flow we're going to use. Also compare with the
proposals from OAuth 2.1 of which flows that are getting deprecated.

Note that introspection endpoint needs a separate auth token than a client
secret. One of our coworkers spent lots of time debugging before he noticed this.
Bottom line: Make sure to ensure you know how the flow works completely before
starting to implementing it.

- Tip on SPA's: "Authorization Code" flow, and perhaps extended using PKCE flow
- Tip on API access (non-web-browser): "Device code" or "Client credentials"

Sample docs: https://oauth.net/2/grant-types/

## Backend

Identity Server is only .NET, but also getting closed down into closed source
and a price model.

Need to seek up a library in Go that helps us with this, or use some third-party
sidecar. Maybe there's some certified backend package?

## Frontend

Use one from https://openid.net/certification/#RPs

This one is used by other internal projects, and has worked well:
https://github.com/damienbod/angular-auth-oidc-client

## Logout on service update

- need persistence of refresh tokens, if we so use a flow that uses them.
- need way to revoke refresh tokens, both automatically and manually

