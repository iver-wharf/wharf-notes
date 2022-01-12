---
date: 2022-01-12T07:22
---

# Multi-repo arguments

In contrast to having a mono-repo.

## Definitions

- Mono repo: All projects and packages coexist in the same Git repository.
  Such as storing the frontend at `src/web/package.json` and the backend at
  `src/api/main.go`

- Multi repo: Using one repository per project or package. This is what
  Wharf is using today, with frontend at <https://github.com/iver-wharf/wharf-web>
  and backend at <https://github.com/iver-wharf/wharf-api>.

## Arguments for wharf-api-client-go vs wharf-api

These are arguments specifically for <https://github.com/iver-wharf/wharf-api-client-go>

In favor of using separate repos, instead of embedding wharf-api-client-go
inside the wharf-api repo:

- **Smaller dependency:** No need to pull in GORM or Sqlite. But now since v2
  that we're depending on wharf-api, this isn't a feature anymore.

- **Versioned separately:** While confusing versioning, it does mean we don't
  have to bump the wharf-api just for a bugfix in wharf-api-client-go.

- **Separate changelogs:** Less clutter in the two changelogs as they are
  separate packages. However also more duplication.

- **Support multiple wharf-api major versions:** wharf-api-client-go is meant
  to support a range of wharf-api versions. Starting with v2 however, we start
  dropping support for v4 and below.

