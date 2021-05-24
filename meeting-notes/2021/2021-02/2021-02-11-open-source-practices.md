---
date: 2021-02-11T10:30
tags: 
  - stub
---

# 2021-02-11 Open Source practices

## Agenda

0. What's our goal here?

1. Do we move everything to the open? (WOs)

   - How do we report our time?
     - Singleton Spark ticket?
     - Mirrored GitHub issues<->Spark tickets/Cure WOs?
       - Automated or manual?

2. Plan features in open documents instead of discussing them in private?

   - Request for Comments (RFC)?
   - NABC?

3. GitHub workflows

   - GitHub projects
   - GitHub milestones
   - GitHub issues
     - Relying on GitHub issues "assignment", or some closed procedure so only we
       internally know who's working on what?
   - GitHub discussions

4. Roadmap

5. Be nice to contributors.

## 0. What's our goal here?

- Press
- Contributions
- Easier to sell
- Giving back to open source! Because we're already relying to heavily on it.

Who's most important? Users vs company?

- Paying -> higher prio.
- Though non-paying/anonymous feature requests/issues are not to be ignored.
- Case by case.
  - Security issues from non-paying users should *usually* be prioritized higher
    than payed feature requests.

## 1. Do we move everything to the open? (WOs)

Now what about GitHub?

### Can we keep all info in the public?

- Feature requests from confidential customers?
  Where do we communicate about this customer?
  
  - Use case: how do we tell the customer that requested feature is done?
    - Option A: Keep track of customer internally (non-public), ex: via Teams
    - Option B: Point customer to our public issue, tell them to subscribe to it

  - Conclusion:

    These are exceptions. We will 99.99% of the time not need to mention the
    customer in our issues anyway. We're devs, not sellers.
    
- For issue descriptions:

  Focus on what's going to be implemented and not the customer that wants it.
  
  - Cons: We'll have to focus more on making the feature descriptions more
    generic to not refer to any Wharf instance over at a customer.
    
  - Pros: We like generic features :)
  
  - Pros: It will only be difficult in the beginning (ultimate heuristic here!)

### How do we report our time?

Singelton Spark ticket.

*Ask for forgiveness instead of permission :)* --- Until managers complain, we
will be using a singleton Spark ticket for time reg.

Potential next steps (if managers complain):
- One ticket per repo?
- One ticket per sprint?

### Do we move all existing WOs?

With GitLab->Cure we decided to not create new issues, but use the old ones
instead of transferring them.

## 2. Plan features in open documents instead of discussing them in private?

1. GitHub issue is created (feature request)
2. Grooming meetings to prio the issues

3. Write up a RFC
4. Send RFC document to coworkers to look at
5. Author of RFC sets deadline when RFC document is considered final
6. Author of RFC makes sure feature is implemented

Grooming meeting will
- prio GitHub issues
- estimate GitHub issues
- not regard RFC's at all

Comparison to now:
- We're not designing before implementing
- We're not reviewing the design

## Next meeting

Didn't have time for it

3. GitHub workflows

   - GitHub projects
   - GitHub milestones
   - GitHub issues
     - Relying on GitHub issues "assignment", or some closed procedure so only we
       internally know who's working on what?
   - GitHub discussions

4. Roadmap

5. Be nice to contributors.

6. Documentation. How to we host it?

Next meeting: [[2021-02-22-open-source-practices-part-2]]#
