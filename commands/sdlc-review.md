---
description: Stage 5 (Deploy) — run the REVIEW.md policy passes (bugs, security, compliance) on the current diff/PR, surface findings without auto-approving, and respect the tiered deploy gates (agent stops at production).
argument-hint: [PR number | branch]
---

# /sdlc-review — policy-based PR review + deploy gates

1. **Review setup.** Reviews come from the managed Code Review service or `claude-code-action` running in CI. Read `REVIEW.md` (if missing, route to `/sdlc-init`).
2. Run each defined pass (bugs/logic, security, compliance vs. `spec.md`/`plan.md`/design principles) on the diff or PR; tag each finding by pass and severity (Important vs. Nit). You may reuse `/code-review` for the bug/logic + reuse pass.
3. Report findings by severity. Findings **inform**; they never auto-approve or auto-block — the `REVIEW.md` threshold plus **branch protection (code-owner sign-off)** govern merge. **Separation of duties: the agent that wrote the code cannot approve it.**
4. When a reviewer tags `@claude` on a comment, address it and push a fix; sweep unresolved comments and failing checks until the PR is green and awaiting only code-owner approval.
5. **Security gate (before any production/client ship).** Run `security-gate.md` — the OWASP-Top-10 + data/secrets checklist. Every item must be green or explicitly risk-accepted by the client in writing. **Do not issue `SDLC_RELEASE_AUTH` until this passes**; blocking findings go back through Build.
6. **Deploy gates** (from `.sdlc/config.yaml` `autonomy`, using the exact commands + tiers in `deploy-profile.md`): development = free, staging = middle ground (logged approval), production = the agent prepares the release, the release manager authorizes, the hook enforces. The prod-gate hook blocks deploy commands until a named release authorization is present (`SDLC_RELEASE_AUTH=<ticket>`); log every gate decision with a timestamp.
7. When review flags the same mistake twice, add the correction to `CLAUDE.md`.

**CI/CD integration (build it in this order — gates must exist first):**
- **Read-only judgment steps first**: `claude -p` in a pipeline job to triage failed builds, summarize flaky tests, or draft changelogs.
- **Then write steps, behind existing gates**: lint fixes, doc updates, review-comment fixes — all arrive as **PRs through branch protection**, never a direct push to main.
- **Sandbox**: agent jobs run in containers under a network policy with short-lived **scoped tokens** and no standing production credentials.
- **Deployment via MCP**: expose `deploy` / `status` / `rollback` as scoped, per-environment tools (an allowlist, not a shell script holding credentials).
- **Rollback is the most-rehearsed path**: a single command, exercised regularly in staging, proven *before* Stage 6 needs it.

**Gate:** the agent acts up to the production gate and cannot cross it; non-interactive runs are attributed to the agent identity. Next (post-deploy): `/sdlc-maintain`.

**Measure:** leading — time to first review (target: minutes); share of review comments resolved without a human touching the branch; share of pipeline failures triaged without paging a human. Lagging — defects/vulnerabilities caught pre-merge vs. escaping to production; gate violations reaching prod before vs. after hooks; DORA metrics (deploy frequency, lead time, change-failure rate, recovery time).
