---
description: Stage 4 (Test) — give the session a quantifiable feedback loop (tests/build/screenshot), iterate until it passes before a human sees it, and maintain the continuous eval set. Verification is part of "done".
---

# /sdlc-test — feedback loop + evals

1. Identify how this repo proves correctness (tests, build, screenshot diff). If there is none, say so and propose the smallest one.
2. Make verification quantifiable ("all tests in test_status.py pass", "screenshot matches the attached mock", "the endpoint returns 200 with the new field"). Iterate until it passes — do not hand unverified work to a human.
3. For bug fixes: reproduce the bug as a failing test, confirm it fails **for the expected reason**, then fix the code — not the test. Declare the fix (`touch .sdlc/BUGFIX`, or set `SDLC_BUGFIX=1`) so the guard freezes the tests during the fix; remove the marker when done. For UI, use a browser/screenshot tool and iterate 2–3 rounds against the mock.
4. Verification is part of "done" — this is documented in `CLAUDE.md` (run tests before reporting complete, paste the output; if a test fails, fix the code, not the test).
5. Maintain evals: 20–50 real tasks as `evals/*.json` (prompt + acceptance checks — tests pass, lint clean, behavior unchanged, policy honored; see the template), run by `.github/workflows/sdlc-evals.yml` on changes to `CLAUDE.md`/skills/hooks and on schedule; the pass-rate threshold gates config merges. Add every production incident as a permanent eval.
6. Report the exact command run and its outcome — never "passing" without having run it and seen it.

**Gate to Deploy:** verification is green and part of the definition of done. Next: `/sdlc-review`.

**Measure:** leading — first-pass CI success rate for agent changes; eval pass-rate over time; speed from a production incident to a permanent eval. Lagging — PR review time per submission and change-failure rate (should fall); regressions caught in CI vs. reaching production.
