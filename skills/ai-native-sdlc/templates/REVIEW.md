# Review policy — <repo>

<!-- Stage 5 (Deploy). Defines the passes Claude runs on every PR. Findings inform; they do not auto-approve or auto-block. Tag each finding by pass and severity. -->

- **Human threshold:** <e.g. code-owner approval required to merge; branch protection enforces it>
- **Excluded paths:** generated code (e.g. `src/gen/**`), vendored deps, lockfiles, and anything CI already enforces

## Passes
Run each pass and tag every finding with its pass and severity.

### Bugs / logic
Correctness, edge cases, broken edge cases, subtle regressions, race conditions.

### Security
Auth/authentication gaps, input validation, secrets, injection, PII in logs, audit logging.

### Compliance
Matches `spec.md`, `plan.md`, and design principles; plus <regulatory / license / data-residency checks for this repo>.

## Important vs. Nit
- **Important:** breaks behavior, leaks data, or breaches policy.
- **Nit:** style, naming.

## Nit policy
Cap nits at <N> per PR (e.g. 5); summarize the rest as a count. Prefer Important findings over style.

## Feedback loop
When review flags the same mistake twice, add the correction to `CLAUDE.md` as part of that review.
Tune this file monthly: rate findings to improve quality, cap nit volume, exclude paths CI already enforces.
