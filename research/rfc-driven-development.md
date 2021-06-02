---
date: 2021-03-22T13:38
---

# RFC driven development

## Life without RFCs

Quoted from a blog post about the ride-sharing app Ride:[^ride-rfc-blogpost]

> In the process of building our apps, I received a private Slack message from
> "a not very happy front-end engineer," who asked:
>
> > *Why was the data dashboard built using React if our front-end stack is
> > based on Ember?*
>
> This made me quickly realize a few important things I shouldn't have missed:
>
> - I didn't know we had added a new tool to our stack.
>
> - Other team members—who should've known about it—didn't know either.
>
> - Someone made an important decision on behalf of our entire team, but the
>   team wasn't included in it.
>
> - No one, including myself, appreciated the surprise.

## Benefits

- Plan ahead before jumping into implementing in code.

- Higer level design agreed upon beforehand so it's not discussed in the code
  PRs.

- Can forward RFCs to stakeholders so they can voice their concerns.

- Anyone with a GitHub account is free to review the RFCs.

- Consider more perspectives. For a backend change a frontender may comment on
  the API design, or a QA may comment on how the performance should be asserted
  in the tests, a DBA may comment on the DB changes, and so on.
  
- Coordinate large teams, letting everyone know what decisions are made and the
  possibility to object, without needing tons of meetings.
  
- Inclusion in descisions leads to increased responsibility. Team usually gets
  a higher sense of purpose in their tasks.
  
- Question *"Why wasn't I consulted about X?"* becomes more rare. A progress
  managers tend to enjoy.
  
- Developers, CTOs, or other roles can participate at the level of abstraction
  that suits them, to delegate minute decisions to others and only review the
  "bigger picture"-affecting RFCs. This leads to people not needing to keep the
  entire system in their head, while still being able to participate in a
  meaningful way.

## References

- RFC driven development (18 Jul 2018), *Engineering Management Space*,
  <https://engineering-management.space/post/rfc-driven-development/>

- J. Pablo Buritica (11 Sep 2017), *opensource.com*,
  <https://opensource.com/article/17/9/6-lessons-rfcs>

[^rust-rfcs]: Rust RFCs, *The Rust RFC Book*, <https://rust-lang.github.io/rfcs/introduction.html>
[^ride-rfc-blogpost]: J. Pablo Buritica (11 Sep 2017), 6 lessons on using technical RFCs as a management tool, *opensource.com* <https://opensource.com/article/17/9/6-lessons-rfcs>
