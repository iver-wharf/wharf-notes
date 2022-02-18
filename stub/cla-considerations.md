---
date: 2022-02-18T21:55
tags:
  - stub
---

# CLA considerations

We currently lack CLA (Contributor License Agreement) in all of our
repositories.

This is not an issue now (2022-02-18) as our only contributors are
employees of Iver.

However, this will be something we must consider BEFORE merging the
first PR from an outside collaborator.

## What we shouldn't do

We shouldn't use a CLA that claims their code as ours (basically
reassigning copyrights from the author to us). It's enticing for the
enterprise mind as this is how job contracts work where all code
written by employees is copyrighted to the employer. But keep in
mind we want to focus on staying true to open source.

Read more: <https://opensource.com/article/19/2/cla-problems>

## What we should do
    
Implement the [DCO (Developer Certificate of Origin)](https://developercertificate.org/)
into our review process, preferrably through some CI tool to make
sure we don't miss out on any, such as <https://clabot.github.io/>.

The DCO is a short and simple CLA that mostly only is in place to
protect us (Iver) from things like:

- People committing stolen code.
- People committing code that's incompatible with our license (eg MIT vs GPLv3).
- Iver getting the blame for someone else's misbehaviour.

It does not reassign the code ownership. The code is still
copyrighted to the author of the code, meaning after the first
PR merged from a collaborator, the source code is no longer
solely owned by Iver, but instead by Iver _AND_ all outside
contributors. Not as a whole, but in part, on a
per-code-snippet basis.

## How we should do it

Enforce all commits from outside collaborators to be signed-off.
The is done by adding the following line at the end of each commit message:

```
Signed-off-by: Jane Doe <jane.doe@example.com>
```

Git has built-in support for this with the `--signoff` flag.

The `Signed-off-by` does not have any meaning in of itself. So in our
`CONTRIBUTING.md` file (in EACH repository) it must state what it implies,
as well as that all commits requires sign-off, how to add it.

We should have to embed the full DCO text inside each repo as
well, as refering to a third-party website is quite volatile in many
regards. Nothing hard though, just copy it into `DCO.txt` and make
sure the `CONTRIBUTING.md` is referring to that file in addition to
the website (<https://developercertificate.org/>)

Could take inspiration from the Linux kernel's documentation: <https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin>

## Why we haven't added it yet

It's up for discussion that needs to be talked over with the board.
As much as the voice of us developers has some weight, it's not our
final decision, but instead something like the legal team of Iver.

So such discussion has been started yet (as of 2022-02-18).

## Examples of CLAs

Some examples of other's CLAs: <https://en.wikipedia.org/wiki/Contributor_License_Agreement>
