---
description: Stage 1 (Plan) — brainstorm with the user until the idea is concrete, then write intent.md (what/why/constraints) and commit it. The entry point of a new SDLC cycle.
argument-hint: [feature slug]
---

# /sdlc-intent — capture intent.md

1. Brainstorm the idea with the user in plain language until it's concrete. Pose the questions an analyst would — the problem, scope, **affected users and systems**, constraints, and **how success is measured** — plus non-goals. Do **not** design a solution here.
2. Write `intent.md` (in the repo's intent home — an `intent/` folder or `docs/sdlc/<slug>/intent.md`) from `~/.claude/skills/ai-native-sdlc/templates/intent.md`, filled in.
3. Read it back; let the user correct misunderstandings.
4. Leave `Status: draft` until the product owner approves; then set `approved`.
5. Commit: `plan: intent for <slug>`. The commit records author, timestamp, and revision history (git log); the product owner's accept/reject is the merge or a closed review thread.

**Gate to Design:** intent approved by the product owner. Next: `/sdlc-spec`. Once the loop is trusted, acceptance of `intent.md` can auto-trigger Design via a version-control webhook.

**Measure:** leading — time from first conversation to committed `intent.md` (target: weeks → hours). Lagging — survival rate (share of intents accepted into Design) and rework (edits to `intent.md` after the first `spec.md` commit).

Never invent constraints or requirements — ask. This is a WHAT / WHY artifact, not HOW.
