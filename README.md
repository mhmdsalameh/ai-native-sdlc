# AI-Native SDLC — a governed development lifecycle for Claude Code

Turn ad-hoc AI coding ("prompt → answer") into a **governed, self-verifying, closed loop**. Six
stages, an orchestrator plus a specialist agent per stage, deterministic guardrail hooks, artifact
templates, and a pre-ship security gate — all version-controlled, so the commit chain is the audit
trail.

```
intent.md → spec.md → plan.md → code + tests → reviewed PR → deploy record → incident intent.md → (loops)
   Plan       Design     Build        Test           Deploy                     Maintain
```

> **New here?** Read [`skills/ai-native-sdlc/HOW-IT-WORKS.md`](skills/ai-native-sdlc/HOW-IT-WORKS.md) —
> a plain-English walkthrough of each stage (what the human does, what the AI does, why).
> Running client work? Read [`skills/ai-native-sdlc/ENGAGEMENT-PLAYBOOK.md`](skills/ai-native-sdlc/ENGAGEMENT-PLAYBOOK.md).

---

## What's inside

| Part | What it is |
|------|-----------|
| **9 commands** | `/sdlc` (map), `/sdlc-init`, one per stage (`intent`/`spec`/`plan`/`test`/`review`/`maintain`), `/sdlc-client`, `/codemap` |
| **7 agents** | `sdlc-orchestrator` + one per stage — use as an orchestrated pipeline or open a session as any one |
| **4 skills** | `ai-native-sdlc` (the loop + templates) plus `state-file`, `codebase-navigation`, `verify-loop` |
| **9 hooks** | deterministic guardrails: protected paths, secret/destructive-command blocks, prod-deploy gate, auto-format, audit logs |
| **Templates** | `intent.md`, `spec.md`, `plan.md`, `REVIEW.md`, `security-gate.md`, `deploy-profile.md`, `bands.yaml`, evals, and a client pack (scope/support/handover) |

## Requirements

- **Claude Code.**
- **Windows + PowerShell** for the hooks (the guardrail scripts are `.ps1`). Commands, agents, skills,
  and templates are cross-platform; only the hook layer is Windows-specific today. On macOS/Linux,
  disable the hooks (see below) or port the scripts to shell.
- **git** — the whole model assumes every artifact is committed.

---

## Install

### Option A — as a Claude Code plugin (recommended for a team)

Add this repo as a plugin marketplace, then install it, from inside Claude Code:

```
/plugin marketplace add <git-url-or-path-to-this-repo>
/plugin install ai-native-sdlc
```

Everyone who installs it gets the same commands, agents, skills, and hooks. Pin a version so upgrades
are deliberate. For non-negotiable gates, distribute via your org's **managed settings**.

### Option B — manual drop-in

Copy the folders into your Claude config:

- **Global (all your projects):** copy `commands/`, `agents/`, `skills/`, `rules/`, and `hooks/*.ps1`
  into `~/.claude/`, then wire the hooks by merging `hooks/hooks.json` into `~/.claude/settings.json`
  (replace `${CLAUDE_PLUGIN_ROOT}` with the absolute path to your `~/.claude`).
- **Per-project:** copy the same folders into the project's `.claude/` directory.

### Turning hooks off

Set `"disableAllHooks": true` in the relevant `settings.json`, or simply omit `hooks/hooks.json`.
Commands, agents, and skills still work without the hooks — you just lose the deterministic guardrails.

---

## Using it

Once installed, in any git repo:

```
/sdlc-init          # scaffold this repo (.sdlc/config, REVIEW.md, security-gate.md, deploy-profile.md, ...)
# fill the blanks in .sdlc/config.yaml (protected paths, prod-deploy patterns)
/sdlc               # shows the map + your current stage
/sdlc-intent        # start a feature: capture intent.md
/sdlc-spec          # → spec.md (your FSD)
/sdlc-plan          # plan first (no edits until approved), then build
/sdlc-test          # self-verify
/sdlc-review        # review + security gate + deploy gates
/sdlc-maintain      # watch production; incidents become new intent.md
```

For paid client work, also run `/sdlc-client` to scaffold the scope/support/handover pack.

The guardrails activate for a repo only once it has `.sdlc/config.yaml` — other repos are untouched.
To drive the whole loop hands-off, start a session as the orchestrator:
`claude --agent sdlc-orchestrator` (it stops at every gate for your approval).

---

## Adopting it in a company

1. **Distribute** via Option A (plugin) so the whole team shares one version; use managed settings for
   the gates individuals must not override.
2. **Map the roles** — product owner (approves intent/spec), engineers (Build), tech lead (higher-risk
   plans + review), security (the policy skills + `security-gate.md`), release manager (prod
   authorization), on-call (Maintain triage).
3. **Pilot on one team / one project**, measure (each stage names its leading + lagging indicators),
   then expand — adopt by pain point, not strict order.
4. **Encode your real policy**: replace the generic templates with the company's security/brand/
   compliance standards as skills, and the must-always-hold rules as hooks.

Full guidance: `skills/ai-native-sdlc/ENGAGEMENT-PLAYBOOK.md` (Part 5).

---

## License

MIT — see `LICENSE`.
