# This repo follows the AI-Native SDLC

Six stages, each committing a versioned artifact. The commit chain is the audit trail.

```
intent.md → spec.md → plan.md → code+tests → reviewed PR → deployment record → incident intent.md → (loops)
```

| Stage | Command | Artifact |
|-------|---------|----------|
| Plan | `/sdlc-intent` | `intent.md` |
| Design | `/sdlc-spec` | `spec.md` |
| Build | `/sdlc-plan` | `plan.md`, then code |
| Test | `/sdlc-test` | tests + evals |
| Deploy | `/sdlc-review` | reviewed PR (per `REVIEW.md`) |
| Maintain | `/sdlc-maintain` | incident `intent.md` (per `bands.yaml`) |

- **Config:** `.sdlc/config.yaml`
- **Enforcement:** `~/.claude/hooks/sdlc-guard.ps1` (protected paths, production gate)
- **Full workflow:** run `/sdlc`
