---
date: 2021-02-22T10:18
tags: 
  - stub
---

# 2021-02-22 Open Source practices, part 2

Continuation from last meeting, #[[2021-02-11-open-source-practices]]

## Agenda

1. GitHub workflows

   - GitHub projects
   - GitHub milestones
   - GitHub issues
     - Relying on GitHub issues "assignment", or some closed procedure so only we
       internally know who's working on what?
   - GitHub discussions

2. Roadmap

3. Be nice to contributors.

4. Documentation. How to we host it?

## 1. GitHub workflows

- Scrum?

  - GitHub lacks:
  
    - Burndown charts
    - Prio integers (has labels though)
    - Estimation integers (has labels though)
    
  - We can polyfill it. Let's perhaps consider it.

- GitHub discussions / StackOverflow topic:

  - Overkill to begin with
  
  - Stay with just chat, until it gets overwhelming with # of questions or
    # of duplicate questions
    
- GitHub milestones

  - Not yet. Start with learning how to version via CHANGELOG.md

## 2. Roadmap

- Ways to do this:

  1. Pinned issue with list of planned features, Sample:

     - [x] ~~Add login~~ (added in 1.1.0)
     - [ ] Add settings
     - [x] ~~Change logo~~ (added in 1.2.0)
     
  2. List of features + planned features in README.md, same as above
  
  3. Milestones with deadlines
  
     - "v1.0.0" vs "ui-redesign": Named milestones will probably not work great.
       We want to use "v1.0.0" as milestone title

  4. Organization-wide GitHub project.

**Decision:** 4. Organization-wide GitHub project.

Users who want a roadmap will have to look at our issues and their priorities,
we will work from top to bottom. For a joined list of all issues/tasks then
we redirect users to the organization-wide GitHub project.

## 3. Be nice to contributors

Think from the perspective of the newcomer, that knows barely anything about
the architecture or previous GitHub issues published by others.

> Bad: "This is posted in the wrong repo. Please post it in iver-wharf/api"
> - Telling user to fix because they're bad
>
> Good: "This more belongs in the iver-wharf/api repo, so I moved it there."
> - Acknowledge that it's an easy misstake, and fix it for them where possible.

## Next meeting

Will be discussed in [[2021-02-26-open-source-practices-part-3]]#

4. Documentation. How do we host it?

   - What we want in the docs?

     - Tutorials, How-to guides, Discussions, Reference.
       (based on https://youtu.be/t4vKPhjcMZg)

   - Where to put it?

     - One repo with all docs

     - Aggregated docs from all repos into 1 web page? GitHub Actions could come
       in handy

     - Keep docs split between repos (kind of how it is today with the docs repo
       vs the OpenAPI/Swagger specs from the APIs)

   - What tool?

     - Docsify.js <http://docsify.js.org/>
     - GitBook <https://www.gitbook.com/>
     - ReadTheDocs <https://readthedocs.org/>
     - Neuron <https://neuron.zettel.page/>
     - Do our own thing w/ some static site generator to convert markdown -> html
