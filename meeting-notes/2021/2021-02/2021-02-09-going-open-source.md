---
date: 2021-02-09T08:18
tags: 
  - stub
---

# 2021-02-09 Going open source

What's our next steps on going open source?

## Agenda

- When?
- Where?
  - GitHub?
- Name?
  - /iver/wharf-api
  - /iver-ics/wharf-api
  - /wharf/api
- License?
  - Expat (MIT)?
  - GPLv3?

## Git repo host

| Product   | FOSS | Self hosted | Service                    |
| -------   | ---- | ----------- | -------                    |
| Gitea     | ✓    | Free        | ✘                          |
| Gogs      | ✓    | Free        | ✘                          |
| GitLab CE | ✓    | Free        | Free <https://gitlab.com>  |
| GitLab EE | ✘    | Costs       | Costs <https://gitlab.com> |
| GitHub    | ✘    | ✘           | Free <https://github.com>  |
| GitHub EE | ✘    | Costs       | Costs <https://github.com> |
| SourceHut | ✓    | Free        | Free <https://sr.ht>       |

Gitea, Gogs, and SourceHut seems the most appropriate.

Gitea & Gogs has promised to implement ForgeFed once it's ready, which makes them
the most promising. GitLab will *maybe* implement it, but that will probably
come much later than Gitea & Gogs, and potentionally only to their EE.

Source on ForgeFed integration:

- Gogs: https://github.com/gogs/gogs/issues/4437
- Gitea: https://github.com/go-gitea/gitea/issues/1612
- GitLab: https://gitlab.com/gitlab-org/gitlab-ee/issues/4517

## License

| License      | OSS | Free | Intended use                                         |
| -------      | --- | ---- | ------------                                         |
| *No license* | ✘   | ✘    | Not yet licensed                                     |
| Expat (MIT)  | ✓   | ✘    |                                                      |
| GNU-GPL v3   | ✓   | ✓    | Restrict usage to free software                      |
| GNU-AGPL v3  | ✓   | ✓    | Enforce providing source code on networked services. |
| GNU-LGPL v3  | ✓   | ✓    | Usable in propriatary software                       |
| GNU-APL      | ✘   | ✘    | README files                                         |
| GNU-FDL      | ✓   | ✓    | Documents/documentation                              |
| Apache v2.0  | ✓   | ✓    | Restrict usage to free software                      |

Definition of free software is that it complies to the following four freedoms:

0. the freedom to use the software for any purpose,
1. the freedom to change the software to suit you needs (access to source code),
2. the freedom to share the software with your friends and neighbors (distribution),
3. and the freedom to share the changes you make.

### Arguments for copy-left

- Stand up for free software, and not just "do open source for PR value"
- It would force us to put more of our stuff in open source
- No risk of competing with propriatary forks
- Protection against patent threats

## Conclusions

- Git provider: GitHub
  
  It's the de-facto standard. It makes it easier for users to contribute, if they
  so wanted to, as ForgeFed is still in early alpha.
  
- GitHub organization name: iver-wharf
  
  I.e., we're going to have:
  
  - github.com/iver-wharf/api
  - github.com/iver-wharf/web
  - github.com/iver-wharf/gitlab
  - github.com/iver-wharf/helm
  - *et.al.*
  
- License: Expat (MIT)

  Copy-left is inticing and has good arguments, but for beginners to open source
  it's not a good idea. The best counterarguments to GPL was:
  
  - Some customers see it as a dealbreaker. If it's copy-left, then they won't
    use it.
    
  - Robert & Björn wants to invite lawyers to the party before we use something
    non-basic. Something that we don't have the resources for *yet*.
    
  - Want to tip toes into open source first before even considering licensing as
    free software.
