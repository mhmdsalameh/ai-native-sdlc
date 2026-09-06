# Optional: add this section to your CLAUDE.md

Paste the block below into your project (or global) `CLAUDE.md` so the lifecycle becomes the default
way work flows, and so `/sdlc` is discoverable. This is optional — the commands, agents, skills, and
hooks work without it; the snippet just makes the SDLC the stated default.

---

## AI-Native SDLC — the default development loop

Feature and project work follows the six-stage AI-native SDLC. Each stage commits a versioned
artifact to git; the commit chain is the audit trail:

`intent.md → spec.md → plan.md → code + tests → reviewed PR → deployment record → incident intent.md → (loops)`

| Stage | Command | Artifact |
|-------|---------|----------|
| Plan | `/sdlc-intent` | `intent.md` (what/why/constraints) |
| Design | `/sdlc-spec` | `spec.md` (requirements + design, policy-flagged) |
| Build | `/sdlc-plan` | `plan.md` in plan mode, then code |
| Test | `/sdlc-test` | tests + continuous evals |
| Deploy | `/sdlc-review` | reviewed PR + security gate + tiered deploy gates |
| Maintain | `/sdlc-maintain` | control-band detection → incident `intent.md` |

- Load the `ai-native-sdlc` skill for the full workflow; `/sdlc` prints the map and detects the stage.
- Run `/sdlc-init` once per repo to scaffold config, review rules, the security gate, the deploy
  profile, and the enforcement wiring. For client work, add `/sdlc-client`.
- Enforcement is real: plan mode blocks edits before an approved plan, and the guardrail hooks block
  edits to protected paths and production-deploy commands without a named release authorization.
