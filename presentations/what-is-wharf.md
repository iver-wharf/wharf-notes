---
date: 2022-02-10T09:34
---

# What is Wharf

## Features

- **CI/CD**, *with current support having emphasis on CD*.

- **Arbitrary code execution** engine. Can run anything that fits inside a
  Docker container.

- **Easy to configure**: build definitions configured in YAML (`.wharf-ci.yml`),
  easy to version control and quick to learn synax.

- **Git forge integration** with GitHub, GitLab, and Azure DevOps.
  Both self-managed Git forges as well as official github.com, gitlab.com, and
  dev.azure.com.

- **Self managed**: Runs builds in your own Kubernetes cluster. No phoning home.

- **Open source**: All code and project planning is open to all, licensed under
  the permissive MIT (aka Expat) license.

## Use cases

- Continuously/automatically deploy when commits reach the `master` branch.

- Build and push Docker images

- Run Ansible or Terraform scripts to deploy VMs

- Build and run tests and show the results in the web interface

  - Unit tests
  - Integration tests
  - E2E tests
  - Security scans

- Deploy services to Kubernetes, in a way allowing Git versioning of Kubernetes
  clusters.

- Custom integrations by using Wharf's REST API.

## History

- Originally an abstraction over Jenkins.

- Started February 2019.

- 11 developers (throughout the years):

  - Fredrik L
  - Jonas G
  - Ewelina S (@iverestefans)
  - Piotr W (@Grimwind)
  - Marek Ł
  - Kalle F (@jilleJr)
  - Tomasz Z (@tomaszzarzeczny-iver)
  - Jens B
  - Martin L
  - Fredrik D (@fredx30)
  - Alexander F (@Alexamakans)

## Future of Wharf

- Completely drop dependency on Jenkins.

- Allow Wharf builds without a full Wharf installation instance.

- Improved security via OpenID Connect and RBAC.

- Better integration with existing Git forges.

- Improve documentation.

- Plugin-architecture for Git forges, allowing users to add support for
  Gitea, Gogs, BitBucket, etc.
