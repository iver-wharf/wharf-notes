---
date: 2021-04-13T09:10
---

# Argo CD

- Company: Argo
- Docs: <https://argoproj.github.io/argo-cd/>
- Source code: <https://github.com/argoproj/argo-cd/>

## Pros of Argo CD

- Tight integration with Kubernetes

  - Diffing wanted vs actual manifests
  - See status of all deployed resources (Running, Pending, Failed)
  - Health checks reporting

- Selective deployments (redeploy only things that failed or changed)

- SSO integration

- Rollback support

- Graph visualization of deployed resources

- CLI

- Prometheus metrics

- Donated to CNCF

- Git GPG integration (verification)

- Super rich documentation

- Status badges from Argo CD

## Pros of Wharf

- Build images, not just deploying them

- Publish more than just Kubernetes resources (docker images, artifacts, etc)
