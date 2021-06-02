---
date: 2021-02-02T17:15
tags: 
  - stub
---

# Volatilities

## Authentication to Wharf

- OpenID / JWT login for users in the frontend
- Access tokens for services
- Login providers
  - LDAP
  - OpenID Connect
  - OAuth 2.0
  - Usernames & hashed passwords in the Wharf DB
  - *Combination? Ex: LDAP + Wharf DB*

## Storage of projects/builds/users data

- Postgres
- Sqlite
- MySQL
- MsSQL

## Storage of logs

- Postgres
- Sqlite
- Elasticsearch
- Files on disk

## Storage of artifacts

- Postgres
- Files on disk
- S3

## Access

- REST API
- Web frontend (Angular)
- gRPC API?

## Communication between components

- MessageQueue
  - RabbitMQ
- REST
  - inter-services communication
    - ex: import-gitlab -> api
  - AJAX
    - ex: web-ng -> api

## Project provider

- Git
  - GitLab
    - self hosted
    - gitlab.com
  - GitHub
    - self hosted
    - github.com
  - Azure DevOps
    - self hosted
    - azuredevops.com
  - Bitbucket
  - Gitea
- GitHub gists
- GitLab snippets
- Local file access
- Other remote file access
  - FTP
  - SSH
- Other VCS
  - Plastic SCM
  - Mercurial (hg)
  - VSTC

## Authentication to provider

- Access tokens (needed to access their APIs)
- SSH (needed for pulling the repo)
- Install as an "App" (applicable to GitHub)
- Username+password?

## Continuous integration

- Auto refresh project via webhooks
- Auto start build given set of rules
  - Tag was pushed
  - Commit was pushed
  - Branch was created/deleted
  - PR/MR was created/closed
- Status changes for Azure DevOps commits
- Status changes for commits
  - Azure DevOps
  - GitLab
  - GitHub (called "checks", and Wharf needs to be installed as a "GitHub app")

## Hosting Wharf

- Kubernetes
  - Deployed via Helm
  - Operator (CRDs)
- Azure
- AWS
- Docker swarm
- Docker compose
- "Bare metal"
 
## Hosting of runners

- Kubernetes
  - Raw pods
  - Operator (CRDs)
- Azure
- AWS
- Docker
- GitHub Actions
- "Bare metal"

## Locality

- Honoring local rules on storing personal information (ex: GDPR)
  - Audit logs (who started a build, who cancelled it, etc.)

## Replication of servers

- Multiple APIs
- Multiple provider APIs
- Multiple builds running at the same time

## Starting a build

- Via frontend
- Via schedule
- Via REST API
- Via other builds

## Test results

- NUnit (.NET)
- XUnit (.NET)
- JUnit (Java)
- Go
