---
name: ai-native-sdlc
description: The AI-native SDLC loop — the six-stage workflow (Plan → Design → Build → Test → Deploy → Maintain) where each stage commits a versioned artifact (intent.md → spec.md → plan.md → code+tests → reviewed PR → deployment record → incident intent.md) and the commit chain is the audit trail. Use when starting or running any feature/project under this SDLC, when the user mentions intent.md/spec.md/plan.md/the SDLC, or to decide which /sdlc-* command drives the current stage.
---

# AI-Native SDLC

Software development as a continuous loop of six stages instead of linear role handoffs. Claude executes; humans keep judgment. Every stage ends by committing a versioned artifact to git — the commit chain **is** the audit trail.

**Thesis:** code is no longer the bottleneck — agentic implementation collapsed it, so the constraint moved to the human-speed stages (planning, review, deploy). This loop redesigns those so they don't become the new bottleneck.

## The artifact chain (source of truth)

```
intent.md → spec.md → plan.md → code + tests → reviewed PR → deployment record → (incident) intent.md → loops back
```

Each artifact is committed with author, timestamp, and the prompt/skill versions that produced it. Never skip an artifact; never duplicate one — for legacy integration, designate one system as authoritative per artifact and link the two.

## The six stages → which command drives each

| Stage | Command | Produces | Gate before moving on |
|-------|---------|----------|------------------------|
| 1 Plan | `/sdlc-intent` | `intent.md` | product owner approves intent |
| 2 Design | `/sdlc-spec` | `spec.md` | flagged policy concerns resolved |
| 3 Build | `/sdlc-plan` | `plan.md` → code | plan approved in plan mode *before any edit* |
| 4 Test | `/sdlc-test` | tests, evals | verification is part of "done" |
| 5 Deploy | `/sdlc-review` | reviewed PR | human threshold met; agent stops at prod gate |
| 6 Maintain | `/sdlc-maintain` | incident `intent.md` | finding triaged, eval added |

Run `/sdlc-init` **once per repo** to scaffold the artifacts, config, and enforcement hooks. `/sdlc` prints this map and detects which stage the repo is in.

## Non-negotiable principles

1. **Artifacts drive handoffs.** A stage isn't done until its artifact is committed to git.
2. **Humans own judgment.** Claude executes; every decision that needs judgment is escalated, not guessed.
3. **Skills encode policy.** Brand / security / compliance / UX live as versioned skills, applied *live during writing* — not discovered in review weeks later.
4. **Every session gets a feedback loop.** Tests / build / screenshot — verification is required before a task is "done". Stronger loop = less human review.
5. **Gates are logged.** Every gate decision (approve / ask / block) is recorded with a timestamp. The agent acts up to the production gate and cannot cross it.
6. **The loop closes.** Maintenance findings become a new `intent.md` and re-enter Plan.
7. **Automation triggers from artifact acceptance, not manual handoff.** An accepted `intent.md` can fire the Design pass; a merged `spec.md` triggers planning; a committed `plan.md` can launch implementation — deterministic handoffs replacing review meetings. Start manual; automate as the loop earns trust.

## Enforcement (what actually blocks)

- **Plan mode** (Stage 3) — Claude reads the codebase but cannot edit until the plan is approved.
- **`hooks/sdlc-guard.ps1`** (PreToolUse) — blocks Edit/Write to protected paths and blocks production-deploy commands until a named release authorization is present. No-op in any repo without `.sdlc/config.yaml`.
- **Continuous evals** (Stage 4) — a CI merge check gates configuration changes on eval pass-rate.

## Adoption & measurement

- **Adopt by pain point, not strict order.** Any stage with no prerequisites (Plan, Design, Build, Test) can start on its own; then follow the dependency graph (Plan→Design/Build, Design→Build/Test, Build→Test/Deploy, Test→Deploy, Deploy→Maintain). Pick the stage that hurts most first.
- **Measure every stage** with a leading and a lagging indicator (each `/sdlc-*` command names its own):
  - *Leading* (predictive, from git/CI logs): time from conversation to committed artifact; time between stage-end artifacts; first-pass CI success; review turnaround (→ minutes).
  - *Lagging* (outcome, from PR/incident history): defect escape rate; rework cycles; intent survival rate; repeat-incident frequency.
- **Audit trail = version control**: git history, CI/CD logs, OpenTelemetry traces, PR threads, and dismissed scan findings together record who requested what, what the agent produced, and who approved it.

## Per-repo files this SDLC expects

- `.sdlc/config.yaml` — stages enabled, protected paths, prod-gate command patterns, autonomy tiers
- `SDLC.md` — the repo's copy of this workflow
- `intent.md` / `spec.md` / `plan.md` — the current cycle's artifacts (or under `docs/sdlc/<slug>/`)
- `REVIEW.md` — PR review passes for this repo
- `security-gate.md` — pre-ship security checklist (OWASP Top 10 + data/secrets); must pass before a production/client release
- `deploy-profile.md` — the repo's hosting/CI/environments/rollback profile (Deploy reads its commands + tiers)
- `bands.yaml` — control-band monitoring config
- `CLAUDE.md` — conventions, commands, architecture (kept under one page; generated via `/init`)
- `docs/client/` — for paid client work: `SCOPE.md`, `SUPPORT.md`, `HANDOVER.md` (scaffold with `/sdlc-client`)

Templates for all of these live in `~/.claude/skills/ai-native-sdlc/templates/`.
