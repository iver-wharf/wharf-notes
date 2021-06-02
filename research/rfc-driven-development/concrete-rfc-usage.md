---
date: 2021-04-13T11:34
---

# Concrete RFC usage

## RFC structure

By inspecting [[rfcs-in-the-wild]]# the following layout is shown:

- **Metadata:** Creation date, RFC ID, name, link to implementation GitHub issues,
  author(s), et.al.
  
- **Summary/introduction:** A short description. Introduction to the RFC

- **Motivation:** Why do we need these changes? What's the problem?

- **Explanation:** This is phrased in countless ways. But it usually includes

  - "From the user's perspective": Rust named this
    "guide-level explanations"[^rust-rfc-template], while others usually just
    name this "detailed design".
    
  - "From the developer's perspective": (Developer of the implementation,
    that is.) This is sometimes omitted and left for the developer to figure
    out on their own.
    
- **Compatability:** Only included here and there. Usually where backward
  compatability is of the essence, such as in programming languages or
  frameworks. If it breaks compatability, will there be a simple upgrade path,
  or how do you inform the users as best as possible? Also consider the
  integration costs.

- **Drawbacks:** Why should this RFC not be implemented? Forces RFC author to
  punch holes into their own proposal. Things like implementation cost, impact
  cost, and so on.

- **Alternatives:** Workarounds or other possible implementations. Usually
  arguments about performance or implementation cost makes the proposed
  implementation prevalent, but making a note that the alternatives has been
  considered.

- **Unresolved questions:** Anything about the RFC that is undecided. May pop up
  during review or be prepopulated by the RFC author.

- **Future possibilities:** Forward compatability and if this RFC can be used
  for any future RFCs, such as having future proposal build on top of this one.
  
- **Acknowledgements:** Omitted by some, usually included in bigger projects.
  Thank and give credit to everyone who has participated in this RFC. That being
  inspiration from blog posts, forums, other issues/RFCs, or even just
  shout-outs to people who have helped the author brainstorm. Seems like it's
  perhaps not just a wholesome tradition, but more of preventing potential
  lawsuits of reported stealing.
  
Sometimes more, sometimes less.

## RFC implementation status

Similar to how Rust uses RFCs:[^rust-rfcs] once RFC is accepted, an issue on the
appropriate repo is created where anyone can assign themselves or ask to be
assigned to then start the work.

A status icon can be added to the RFC using shields.io. Something like:

![GitHub issue detail](https://img.shields.io/github/issues/detail/state/rust-lang/rust/76578?logo=github&style=for-the-badge)

## Dealing with low participation rate

There's usually multiple reasons, of some that appear can be:[^ride-rfc-blogpost]

- Don't find the time because

  - too much going on, or
  - need better personal time management.

- Not interested in reviewing or authoring RFCs.

- Bad user experience when participating.

Good solution might be to add a scheduled item in their calendars for when they
shall review some RFCs.

[^rust-rfc-template]: Rust RFC template (at commit `83e82a1`), <https://github.com/rust-lang/rfcs/blob/83e82a1/0000-template.md>
[^rust-rfcs]: Rust RFCs, *The Rust RFC Book*, <http://rust-lang.github.io/rfcs/introduction.html>
[^ride-rfc-blogpost]: J. Pablo Buritica (11 Sep 2017), 6 lessons on using technical RFCs as a management tool, *opensource.com* <https://opensource.com/article/17/9/6-lessons-rfcs>
