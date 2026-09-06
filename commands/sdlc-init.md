---
description: Scaffold the AI-native SDLC into the current repo — .sdlc/config.yaml, SDLC.md, REVIEW.md, bands.yaml, the eval workflow, artifact dirs, and the enforcement hook wiring. Idempotent; never overwrites existing files.
argument-hint: [--minimal]
---

# /sdlc-init — scaffold this repo for the AI-native SDLC

Templates live in `~/.claude/skills/ai-native-sdlc/templates/`. Load the `ai-native-sdlc` skill first.

## Steps

1. Confirm this is a git repo (`git rev-parse --is-inside-work-tree`). If not, offer `git init` — do not proceed without it.
2. For each target, create it from the template **only if it does not already exist** (never overwrite; report each as created vs. skipped-exists):
   - `.sdlc/config.yaml`  ← `templates/config.yaml`
   - `SDLC.md`            ← `templates/SDLC.md`
   - `REVIEW.md`          ← `templates/REVIEW.md`
   - `security-gate.md`   ← `templates/security-gate.md`
   - `deploy-profile.md`  ← `templates/deploy-profile.md`
   - `bands.yaml`         ← `templates/bands.yaml`
   - `.github/workflows/sdlc-evals.yml` ← `templates/eval.yml`  (skip when `--minimal`)
   - `evals/example.json` ← `templates/eval-example.json`  (skip when `--minimal`)
   - `docs/sdlc/.gitkeep` (home for per-feature `intent`/`spec`/`plan`)
3. If `CLAUDE.md` is missing, run `/init` to generate it, then trim to one page.
4. Wire enforcement into the repo's `.claude/settings.json` PreToolUse (matcher `Edit|Write|Bash`) pointing at `~/.claude/hooks/sdlc-guard.ps1`. If `.claude/settings.json` already exists, **merge** — never clobber existing hooks. (Note: if the user's *global* settings already wire this guard, per-repo wiring is optional — the guard is global and repo-activated.)
5. Ask the user to fill the placeholders in `.sdlc/config.yaml` — protected paths and prod-gate patterns drive the guard.
6. Commit: `chore: scaffold AI-native SDLC`.
7. Print the stage map and say the next command is `/sdlc-intent`. For a paid client build, also run `/sdlc-client` to scaffold the scope/support/handover pack.

Use the Write tool for each file (Read a template, then Write the target). Never script the file creation.
