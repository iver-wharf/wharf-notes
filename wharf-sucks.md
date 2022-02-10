---
date: 2021-02-23T14:57
---

# Wharf sucks

The project is rotten from the core. It's difficult to get right, but we need to
clean it up before we can be proud of it.

It's horribly difficult to maintain and to add features.

## Motive

It's easy to create ***a*** CI/CD tool, but it's much harder to create ***the***
CI/CD tool.

Do we want our product to compete with the market, or do we want to make a great
product that you actually can weigh pros/cons compared to others?

Currently, Wharf holds all cons compared to other solutions, such as CircleCI,
DigitalOcean, Argo CD, GitLab CI/CD, GitHub Actions, AppVeyor, Jenkins, Azure
DevOps...

The common response from outsiders of Wharf has been:

> Oh it's like *(insert any of the above CI/CD solutions here)*, but bad.

## Issues

- All repos are based on POC's. Nothing we want to sell or have in production.
  POC's are meant to proove that a concept can be achived. All repos looks like
  a hobby project from someone who just started learning Go, and that's because
  it is. Suspision is that the original developer of Wharf did not intend Wharf
  to be adopted by customers, nor to be further developed in a stable manner.

- Feature-poor. Project has thousands of hours put into it, and yet its list of
  features is so close to empty and quality in its infrastructure is close to
  zero.

  > In our defence, there has only been a fraction of that time where anyone
  > worked full time on Wharf.

- Convoluted to deploy. It's a horrible experience trying to deploy Wharf.

  > It's easier now since the release of wharf-helm v1 <https://github.com/iver-wharf/wharf-helm/blob/master/charts/wharf-helm/README.md>,
  > but the Jenkins dependency is still obstructing the one-command-install.

- Logs are stored in a table inside the database instead of on disk.

- Logs are not stored per-step, but aggregated per-build, so if you start a build
  that runs 2+ steps simontaneously (which most of our Wharf setups does)
  then the logs will be completely useless as they are a mess of all the logs
  from all the different steps, and there's no way to distinguish between them.

- Imported projects are referenced by display name and full protocol instead of
  project ID and host domain name. Example: `http://gitlab.com/foo` and
  `https://gitlab.com/foo` are two completely separate projects to Wharf.
  If it has the display name `Foo`, then Go get's completely confused.

- Logic to import projects are up to the provider plugins to figure out,
  duplicated code.

- List of providers is hardcoded into the frontend.

- Adding a non-Git based provider is near impossible with the current
  architecture.

- `.wharf-ci.yml` syntax is so full of "magic strings" and conventions that it's
  very hard for newcomers to understand.

- Step types property naming convention mixes between kebab-case, snake\_case,
  and camelCasing. Prime example is the `nuget-package` step type:

  ```yaml
  nuget-package:
    version: 1.0.0
    project-path: src/MyDotNetProject
    skip_duplicate: false
    certificatesMountPath: /usr/local/share/ca-certificates
  ```

- The variable syntax in Wharf, `${example}`, collides with bash, Dockerfiles,
  and many other systems that has variables. [[different-variable-syntaxes]]#

- Security: You can do `GET /api/tokens` anonymously to get list of all PATs.

- Security: Data breach on the the DB -> access to all PATs.

- Security: No login to start a build. Whole system is designed around anonymous
  access.

  > OpenID Connect auth is soon done, courtsey of [RFC-0013](https://iver-wharf.github.io/rfcs/published/0013-authentication)

- Jenkins dependency (obviously on this list)

  > Work has begin now with [RFC-0025](https://iver-wharf.github.io/rfcs/published/0025-wharf-cmd-provisioning)
  > published.

- API: Use of `OnDelete:RESTRICT` instead of `OnDelete:CASCADE` makes it almost
  impossible to make fine edits in the database, and error-prone when trying
  to update it via code.

## How to resolve

Pick and choose. All points needs to be worked through.

## What Wharf could shine with

- Open source and self hosted: a beautiful combo. Though look at Jenkins, GitLab
  CI/CD, Argo CD, and then this dies. Other [[similar-products]]# has also been
  spotted.

- Lightweight: It's built with Go, so our Docker images can be based off of
  `scratch`, though we still require Jenkins, but that's something we're working
  on.

- Easy to setup: HAH! Funny. Wharf is the most convoluted CI/CD solution you'll
  find on the market when it comes to setting up. Does not need this way, and
  we're working on making this easier, but it is the worst at the moment.

- Run locally, without backend: CircleCI has a lightweight CLI for this, though
  it's majorly underpowered, probably intentionally as their project is
  delivered as a SaaS. If Wharf can pull this off, then this would mean it could
  even compete with local execution environments such as Cake (C\#), Fake (F\#),
  Make, *random PowerShell scripts*, and those kinds of systems. Writing 1 (one)
  `.wharf-ci.yml` file and telling Wharf to either run locally or in Kubernetes
  would be a huge boost that actually no other (major) CI/CD tooling has shown
  capability of.

  > Work has begin now with [RFC-0025](https://iver-wharf.github.io/rfcs/published/0025-wharf-cmd-provisioning)
  > published.

## Resolved

- RabbitMQ dependency, that is barely even used. (Kalle: I take blame for this
  one, as I suggested it)

  > RabbitMQ support has been removed since wharf-api v5 by
  > [wharf-api#102](https://github.com/iver-wharf/wharf-api/pull/102)
  > May be added back later with a more proper implementation.

- API: Use of database types as request or response body types, leading to the
  OpenAPI spec suggesting that `POST /project` has to specify the project ID.

  > Fixed by [RFC-0016](https://iver-wharf.github.io/rfcs/published/0016-wharf-api-endpoints-cleanup)

- API: Mix of plural and singular endpoints, ex:
  `GET /projects/{projectid}/builds` vs `GET /project/{projectid}`

  > Fixed by [RFC-0016](https://iver-wharf.github.io/rfcs/published/0016-wharf-api-endpoints-cleanup)

- Generated TypeScript projects has horrible automatic naming. Instead of
  `getProjectById`, we have `projectProjectidGet` (the `i` in `id` is actually
  lowercase...)

  > Fixed by [RFC-0016](https://iver-wharf.github.io/rfcs/published/0016-wharf-api-endpoints-cleanup)
