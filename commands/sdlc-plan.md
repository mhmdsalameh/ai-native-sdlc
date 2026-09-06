---
description: Stage 3 (Build) — enter plan mode, read spec.md and the codebase without editing, produce plan.md (files, work order, tests), get it approved, THEN implement. Enforces design-review-before-code.
argument-hint: [feature slug]
---

# /sdlc-plan — plan.md, then build

**Prereq:** an approved `spec.md`.

1. **Enter plan mode** (EnterPlanMode) — no edits until the plan is approved.
2. Read `spec.md` and the codebase. Produce a plan naming every file touched, the work order, and the tests. For a bug fix, the failing test comes **first**.
3. Present the plan; let the engineer interrogate breakage, risky steps, and alternatives. Iterate until someone unfamiliar with the conversation could implement from the plan alone.
4. On approval, write `plan.md` from `~/.claude/skills/ai-native-sdlc/templates/plan.md` and commit: `build: plan for <slug>` (revisions log with approval attribution). The engineer approves routine changes; higher-risk work goes to the tech lead or architect.
5. Exit plan mode and implement — aim for a single clean pass.
6. If implementation departs from the plan, update `plan.md` in the same commit so it matches the merged diff.

**Gate to Test:** plan approved before any file was edited. Next: `/sdlc-test`.

**Supporting practices (Build):**
- **Guardrails** run here (the build phase fires hooks most): `sdlc-guard`/`protect-files` block protected paths and secrets; `format-file` formats after edits. Keep build-phase hooks fast and file-scoped; heavier checks (full suite) belong at commit/PR. Approval-requesting hooks belong in Deploy, not Build.
- **Auto mode** is the mature default for routine work once guardrails are proven (tight `spec.md`, small blast radius, well-covered code): review shifts from watching edits to reviewing the artifact after a longer autonomous session.
- **Parallel work**: split independent tasks (from the plan) across separate Claude sessions each in its own git worktree; turn recurring jobs (verify, simplify, research) into subagents. The `sdlc-orchestrator` coordinates; the ceiling is how many streams one person can review properly.

**Measure:** leading — share of changes merging on the first implementation pass; time from plan approval to merged PR. Lagging — rework cycles per change; how often the merged diff still matches committed `plan.md`.
