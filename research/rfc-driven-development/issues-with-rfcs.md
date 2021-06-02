---
date: 2021-03-22T13:38
---

# Issues with RFCs

## Takes time

Can induce feeling that less progress is being made.

But if we keep it up then we will *eventually* see the benifits outweigh this
issue, hopefully even on the subconcious level.

## Endless discussions

New facts are found, people disagree, discussions are going in circles, and no
real descision is actually made. This can result in RFCs taking weeks to be
accepted.

Here you either reject or postpone the RFC to end the discussion, or if there's
a majority vote then settle and agree to disagree. If the feature is critical
then book a meeting to resolve it so you can proceed with the implementation.

## Incompatible with Scrum

The RFC review period has a very fluctuating duration. Difficult to fit into
sprints.

But once it's accepted then regular SCRUM processes can continue. Integration
with SCRUM is difficult, but the two methodologies can both be used at the same
time in parallel.

## Unclear what needs RFC

No clear border of when to do a RFC and when to just jump into implementing
right away. Bugs vs new features? Breaking changes? Big impact on users?
Architectural design changes?

Even some small bug fixes could need RFCs. This is case-by-case basis. Rust
declares that anything "substantial" shall be done through RFCs with the
following definition:[^rust-rfcs]

> What constitutes a "substantial" change is evolving based on community norms
> and varies depending on what part of the ecosystem you are proposing to
> change /.../ [followed by some examples]

A rule of thumb from J. Pablo Buritica (11 Sep 2017)[^ride-rfc-blogpost] was:

> In general, if you're asking, *"Should I write an RFC for this?"*, the answer
> probably is, *"If you need to ask, you probably should."*

## RFC and actual implementation may differ

You plan ahead but when it gets to implementing you unravel something that
changes the design. What to do with the RFC in this case?

Common strategy is to leave RFCs as read-only, and to be clear that RFCs are
just a suggestions and not documentation. RFCs are not the source of truth; the
code is.

## Some RFC reviews are faster than others

Frontend RFC usually completes before the backend. Web may begin to be
implemented before the backend RFC is even accepted. This bottlenecks features
and could lead to incompatabilities in the integration, leading to redo the
frontend code once the backend has been decided upon.

Try to identify these dependencies, and the frontend RFC could be left open
until the backend RFC is accepted to intentionally hault the frontend. Or accept
the risk and deal with the integration conflict when it comes.

## Fear of discussions you don't grasp

Reviewing or authoring RFCs with little knowledge in certain fields is natural,
but that sometimes haults people from taking the step and doing it.

One of the tips from J. Pablo Buritica (11 Sep 2017)[^ride-rfc-blogpost] was to
have a "[newbie]" tag that you add on reviews or RFC sections where you felt
that you lacked expertice, context, or confidence. As Buritica explained, it
enabled psychological safety for the author to know that no senior will come and
bash them for their mistakes.

## Licensing RFCs

As explored by the `2044_license_rfcs` Rust RFC[^rust-rfc-2044], licensing RFCs
can be tricky. If left unlicensed then each RFC falls under "License Grant to
Other Users" clause from [GitHub's ToS](https://help.github.com/articles/github-terms-of-service/#5-license-grant-to-other-users)
which gives some protection but also some limitations.

The appropriate license to choose is the same license as the product. That way
you're free to use code snippets in RFCs as well as implementations based on
code written for RFCs.

[^rust-rfcs]: Rust RFCs, *The Rust RFC Book*, <https://rust-lang.github.io/rfcs/introduction.html>
[^rust-rfc-2044]: License RFCs, *The Rust RFC Book*, <https://rust-lang.github.io/rfcs/2044-license-rfcs.html>
[^ride-rfc-blogpost]: J. Pablo Buritica (11 Sep 2017), 6 lessons on using technical RFCs as a management tool, *opensource.com* <https://opensource.com/article/17/9/6-lessons-rfcs>
