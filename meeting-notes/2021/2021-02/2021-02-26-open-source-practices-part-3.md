---
date: 2021-02-26T16:04
tags: 
  - meeting
---

# 2021-02-26 Open Source practices, part 3

## Agenda

4. Documentation. How do we host it?

   - What we want in the docs?

     - Tutorials, How-to guides, Discussions, Reference.
       (based on https://youtu.be/t4vKPhjcMZg)

   - Where to put it?

     - One repo with all docs

     - Aggregated docs from all repos into 1 web page? GitHub Actions/Wharf could
       come in handy

     - Keep docs split between repos (kind of how it is today with the docs repo
       vs the OpenAPI/Swagger specs from the APIs)

   - What tool?

     - Docsify.js <https://docsify.js.org/>
     - GitBook <https://www.gitbook.com/>
     - ReadTheDocs <https://readthedocs.org/>
     - Neuron <https://neuron.zettel.page/>
     - Do our own thing w/ some static site generator to convert markdown -> html

## Where to put it?

- One repo

  - Pros

    - easier to deploy docs
    - touch docs of multiple repos at the same time in the same MR/PR

  - Cons
  
    - 2 MRs/PRs for every new feature that has to be documented, or it's
      forgotten

- Aggregated

  - Pros
  
    - change docs in the same MR/PR as the one where you change the code
    
  - Cons
  
    - more difficult to link between documentation cross-repos

## Conclusions

Let's not overthink it

Where to place it: One repo, to not keep it scattered. Milder to our brains in
grasping everything.

Tool: Docsify.js <https://docsify.js.org>

Multiple .md files. Rule of thumb: write in same .md file,
<abbr title="Too Much Information">TMI</abbr> -> split.
