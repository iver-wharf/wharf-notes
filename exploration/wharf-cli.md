---
date: 2021-02-05T10:44
tags: 
  - stub
---

# Wharf CLI

## Commands

```sh
$ wharf build --dry-run
$ wharf lint
$ wharf init --template dotnet
```

Building with plugins, see: [[wharf-cli-plugins]]#

## Configuration

Sample `wharf.toml` file:

```toml
[definitions]
git.repo = https://gitlab.local/wharf-project/definitions

[[building.plugins]]
name = local
enabled = true

[[building.plugins]]
name = container
enabled = true

[[building.plugins]]
name = kubernetes
enabled = true
```

