---
name: state-file
description: Create and maintain STATE.md, the project-knowledge memory. Use at the START of every new project to seed it (mandatory scaffold, alongside CODEMAP.md), and on any ongoing project to record verified facts, open failures, and lessons so the next session does not re-derive them.
---

---
description: Per-project STATE.md as knowledge memory — what we KNOW, distinct from FEATURES.json (what to DO)
---

# Project Knowledge Memory — STATE.md

FEATURES.json tracks what to build. STATE.md tracks what we've learned building it. Without STATE.md, every session re-derives facts the last session already proved.

## When to create it

**Always, at the start of any new project — before the first line of code.** STATE.md is not
earned by a project growing large enough; it is part of the scaffold, like a README or a
.gitignore. Create it seeded from the template below even when there is nothing yet to record.
An empty `## Verified facts` section on day one is correct. A missing STATE.md never is.

Waiting until a project "spans multiple sessions" is the failure mode: by the time you notice,
session one's findings are already gone.

The only exception: a one-off fix in an existing repo you will not return to.

**Location**: repo root `STATE.md`, or `.claude/STATE.md` if the root is noisy.

If STATE.md is missing at session start on any project you are actively building, create it
then — do not proceed into implementation without it.

## The five-stage knowledge progression

Knowledge matures through five stages. Move entries up as they ripen; never let them stagnate at stage 1.

```
fail → investigate → verify → distill → consult
```

- **fail**: something broke; document it with enough detail to reproduce
- **investigate**: form a hypothesis; find the root cause
- **verify**: turn the hypothesis into a checked fact (run the command, read the output, record both)
- **distill**: turn the verified fact into a rule that applies beyond this one case
- **consult**: read the rule at session start instead of re-deriving it

An entry that never leaves `Open failures` is a signal: either it isn't worth understanding, or it hasn't been pursued hard enough.

## Template

Copy this verbatim and fill in. Delete placeholder comments before committing.

```markdown
# STATE.md — <project name>

## Verified facts
<!-- Things we stopped guessing about. Every entry MUST cite how it was verified. -->
<!-- Format: - [YYYY-MM-DD] <fact> — verified by: `<command or query>` -->

## General rules
<!-- Distilled rules that apply beyond the specific case. Consult before re-deriving. -->
<!-- Format: - <rule> (derived from: <brief source>) -->

## Open failures
<!-- Stage 1–2 work in progress: what failed, current hypothesis, repro pointer. -->
<!-- Format: - [YYYY-MM-DD] <what failed> | hypothesis: <why> | repro: <pointer> -->

## Lessons learned
<!-- Project-specific distillations not broad enough for a shared skill. -->
<!-- Cross-project lessons go to ~/.claude/skills/ instead. -->

## Last session
<!-- Timestamped resume pointer. One block per session; keep the last 2–3. -->
<!--
### YYYY-MM-DD
- tried: <what was attempted>
- passed: <what worked>
- failed: <what didn't>
- next: <exact next action>
-->
```

## Operational rules

**Write before walking away.** Every non-trivial session ends by updating STATE.md — at minimum the `## Last session` block. A session that ends without a write forces the next one to restart from zero.

**Read at session start.** STATE.md is read in boot sequence step 3, alongside FEATURES.json (see session-startup rule). Read it before touching code.

## Hygiene

- An entry that turns out wrong gets **corrected**, not appended around. Stale truths are worse than gaps.
- An unverified guess never sits in `## Verified facts`. It stays in `## Open failures` with a `hypothesis:` label until a command proves it.
- Prune entries that are no longer true. A fact that was true last month and is false today will mislead the next session just as badly as never having written it.
- When a lesson is broad enough to apply across projects, promote it to `~/.claude/skills/` and remove it from `## Lessons learned`.

## What goes where

| Question | File |
|----------|------|
| What features need to be built, and are they done? | `FEATURES.json` |
| What do we know about this project's behavior and pitfalls? | `STATE.md` |
| Where does code live, and what calls what? | `CODEMAP.md` |
| What facts persist across all projects (cross-project memory)? | `~/.claude/projects/<project>/memory/MEMORY.md` |
| What reusable procedures apply across projects? | `~/.claude/skills/<skill>/SKILL.md` |
