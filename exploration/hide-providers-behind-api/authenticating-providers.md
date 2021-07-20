---
date: 2021-07-20
---

# Authenticating providers

## Old solution

Basic auth using personal access token (PAT) or username+password from some
user.

This is insecure because the same credentials are used over and over again, and
it should at least be possible for token rotation such as with GitHub Apps
that uses private keys and 1h lifetimed installation tokens.

Backward compatability is vital here. Basic auth should still be possible, while
heavily discouraged, given that we have an alternative and more secure solution.

## New solution

- TODO: Consider auth flow for GitHub Apps, how to allow for this in a generic
  manner, so the wharf-api doesn't have to know about this auth flow? Or do we
  add this into wharf-api as this follows the OAuth 2.0 code flow?

  1. Forward user to [create a new GitHub App from a generated manifest.](https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app-from-a-manifest)

  2. Users are redirected back to Wharf with a OTP token

  3. wharf-provider-github uses token to obtain private key and app ID

  4. wharf-api stores private key and app ID in DB

  5. On each request to the wharf-provider-github, the wharf-api populates the
     credentials with the private key and app ID, that the wharf-provider-github
     can use to generate the JWT and obtain the installation tokens.

- TODO: Consider auth flow for GitLab
- TODO: Consider auth flow for Azure DevOps

