---
date: 2021-03-10T09:03
---

# Repo name changes

## Why not old names

Our old repo names are bad because if you fork the api, you get the fork as
`github.com/yourname/api`.

## Repo naming convention

- *All:*

  - All lowercase and dash ( `-` ) separated. Aka "kebab-casing".
  
- GitHub Pages documentation:

  - Format: `${ORGANISATION}.github.io`
  - Where `${ORGANISATION}` is the name of the GitHub organisation

- Go library:

  - Suffix with `-go`
  - Have same name as package name in `.go` files, or place package under
    `/pkg/thename` inside repo. Last segment on full package name shall always
    be the Go package name, with exception to any `-go` suffixes.
  - Ex:
  
    - `/iver-wharf/messagebus-go`
    - `/iver-wharf/wharf-api-client-go/pkg/wharfapi`
  
- Providers:

  - Format: `wharf-provider-${PROVIDER_NAME}`
  - Where `${PROVIDER_NAME}` is name of repo provider service.
  
- Other:

  - Prefixed with `wharf-`

## Mapping

| Old name (on our GitLab)            | New name (GitHub)                              |
| ------------------------            | -----------------                              |
| `/tools/wharf-client`               | `/iver-wharf/wharf-api-client-go/pkg/wharfapi` |
| `/tools/wharf-message-bus-sender`   | `/iver-wharf/messagebus-go`                    |
| `/tools/wharf-project/docs`         | `/iver-wharf/iver-wharf.github.io`             |
| `/tools/wharf-project/api`          | `/iver-wharf/wharf-api`                        |
| `/tools/wharf-project/architecture` | `/iver-wharf/wharf-design`                     |
| `/tools/wharf-project/builder`      | *removed*                                      |
| `/tools/wharf-project/cmd`          | `/iver-wharf/wharf-cmd`                        |
| `/tools/wharf-project/deploy`       | *stay in our GitLab*                           |
| `/tools/wharf-project/github`       | `/iver-wharf/wharf-provider-github`            |
| `/tools/wharf-project/gitlab`       | `/iver-wharf/wharf-provider-gitlab`            |
| `/tools/wharf-project/azuredevops`  | `/iver-wharf/wharf-provider-azuredevops`       |
| `/tools/wharf-project/web`          | *removed*                                      |
| `/tools/wharf-project/web-ng`       | `/iver-wharf/wharf-web`                        |
| `/tools/wharf-project/wharf-old`    | *removed*                                      |

This implies that the following Go packages shall be renamed:

- `/tools/wharf-message-bus-sender`: `messagebussender` &rarr; `messagebus`
- `/tools/wharf-client`: `wharf` &rarr; `wharfapi`

## Future naming conventions

- Provider temaplates:

  - Format: `wharf-provider-template-${LANG_NAME}`
  - Where `${LANG_NAME}` is name of programming language and optionally tool.
  - Ex:

    - `/iver-wharf/wharf-provider-template-go`
    - `/iver-wharf/wharf-provider-template-dotnet`
    - `/iver-wharf/wharf-provider-template-typescript-nodejs`

- .NET libraries:

  - Stay with kebab-casing.
  - Suffixed with `-dotnet`
  - Ex:

    - `/iver-wharf/wharf-api-client-dotnet`
    - `/iver-wharf/wharf-provider-template-dotnet`
