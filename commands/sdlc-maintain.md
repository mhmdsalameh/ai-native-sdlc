---
description: Stage 6 (Maintain) — run control-band detection from bands.yaml, and when a band breaches, diagnose within the allowed tier and write findings as a new intent.md that re-enters Plan. Closes the loop.
---

# /sdlc-maintain — control-band detection → intent.md

A **deterministic, unit-tested detection script** (no model) watches each metric in `bands.yaml` over its rolling window (Western Electric rules) and invokes Claude only at 2σ+. Claude does not compute the band.

1. On invocation, read `bands.yaml` and act **within the tier the config grants, no further**: **1σ** log only; **2σ** diagnose read-only (tools scoped per the tier); **3σ** may act — open a PR (still through the review gate) or trigger a pre-approved runbook. Claude runs stateless and sandboxed.
2. On a breach that warrants action, write the diagnosis as `intent.md` (anomaly + evidence, proposed outcome, affected systems, open questions) into the triage queue — this re-enters Stage 1.
3. Route product-facing findings to the product owner; on-call triages the rest. Dismissals tune the band thresholds to reduce noise.
4. Add an eval for each incident so the same class can't regress. Log every invocation, finding, and triage decision with a timestamp.

**Recurring codebase scans (Claude Security):** scheduled scans (weekly default) run on the most capable model against connected repos; every finding carries a validation result and confidence rating. Triage: dismiss with a recorded reason; **bounded** findings → open the suggested patch in Claude Code and merge through the PR gate; **wider** findings → write as `intent.md` and enter at Stage 1. Add an eval per released fix. Fixes flow through PR review, never directly from the scan.

**Claude on-call (Claude Tag):** when tagged in a Slack/Teams incident channel, act as first responder with channel history for context; the team can steer in real time. Via MCP, verify metrics have returned to baseline and confirm in-thread. Write the post-mortem to a version-controlled lessons file. Small bounded fixes arrive as PRs; larger work becomes an `intent.md` for Stage 1.

**Loops back to** `/sdlc-intent`. **Measure:** leading — time from band breach to `intent.md` in the triage queue; share of connected repos on schedule. Lagging — share of findings that become merged fixes; repeat incidents by class (should fall as evals accumulate).
