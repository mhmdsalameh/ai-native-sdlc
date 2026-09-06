---
description: Stage 2 (Design) — turn an approved intent.md into spec.md (testable requirements + design) in one session with policy skills active, flagging security/compliance/brand/UX concerns. Commit alongside intent.md.
argument-hint: [feature slug]
---

# /sdlc-spec — intent.md → spec.md

**Prereq:** an approved `intent.md`. If it's missing or unapproved, stop and route to `/sdlc-intent`.

1. Read `intent.md`. Load the repo's policy skills (security, compliance, brand, UX) if present, and apply them so the spec conforms to brand guidelines, security policies, compliance, and UX standards.
2. Produce `spec.md` from `~/.claude/skills/ai-native-sdlc/templates/spec.md` in one pass: problem & proposed solution, affected users and systems, numbered testable requirements, the design (decisions with rationale), constraints & dependencies, a Policy concerns table (each concern flagged with an owner), success criteria, and open questions resolved or carried forward.
3. Review the spec against the intent with the user: does it solve the stated problem? Are the intent's open questions answered or explicitly carried forward?
4. Show the user the flagged concerns. Route each to its named policy owner; they resolve it **before** Build.
5. Record the prompt / skill versions used (logged in version control).
6. Commit: `design: spec for <slug>` alongside `intent.md`.

**Gate to Build:** flagged policy concerns resolved, and the product owner explicitly approves progression to Build — consulting the technical lead for higher-risk items. A human always makes this call. Next: `/sdlc-plan`. Once trusted, an `intent.md` merge can auto-fire a non-interactive job (org skills loaded) that commits `spec.md` as a PR for review.

**Measure:** leading — elapsed time between the `intent.md` and `spec.md` commits. Lagging — requirements rework (count `spec.md` commits dated after the first `plan.md` commit for the same change).

Every requirement must trace to the intent — flag anything that doesn't.
