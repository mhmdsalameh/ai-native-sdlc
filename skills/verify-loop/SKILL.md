---
description: Run when delegating non-trivial work that needs independent verification. Mechanical checks first; a separate model verifier is spawned only for rubric criteria a command cannot answer. Loops on gaps up to 2 times before escalating.
name: verify-loop
---

# Verify Loop

<!-- Sole copy of the verifier-loop procedure. The always-on `rules/verifier-loop.md` was removed 2026-06-23 to cut always-on context. Rebalanced 2026-08-05: the model verifier is now conditional, not automatic — an unconditional verifier doubled the cost of every delegation. -->

## When this applies

Only for delegated work where **being wrong is expensive and not command-detectable** — security-sensitive logic, data migrations, a contract other code depends on, anything irreversible.

For everything else, the verification is: run the project's checks. Green typecheck + lint + tests is a complete verification of everything those commands cover. Do not spawn a model to re-read code that a compiler already proved.

## Procedure

### Step 1 — Write the rubric

Create `.verify/rubric.md` before spawning the maker. Every criterion binary (pass/fail).

Split the criteria into two lists as you write them:
- **Command-answerable** — a check a command can decide (tests pass, no type errors, no TODO markers, file exists, endpoint returns 200).
- **Judgment-required** — needs a model to read and assess (all error cases handled, no auth bypass in the logic, the abstraction matches the stated design).

If the judgment list is **empty**, there is no model verifier in this loop. Commands are the whole gate.

### Step 2 — Run the mechanical checks

```
npm test / pytest / cargo test   → all tests pass
npm run lint / ruff / eslint     → no lint errors
tsc --noEmit / mypy              → no type errors
grep -r "TODO\|FIXME" <paths>    → zero hits (if the rubric requires it)
```

Any failure goes back to the maker (continue it via `SendMessage` — it's warm) before anything else happens.

### Step 3 — Spawn the maker

Inputs: task description + path to `.verify/rubric.md`. Nothing else.
Outputs: the artifact, and the list of file paths for verification.

The maker is told the rubric up front — most gaps are avoided rather than caught.

### Step 4 — Verify the judgment criteria (conditional)

**Skip entirely if the judgment list is empty and mechanical checks are green.** Record the pass and move on.

Otherwise spawn one independent verifier:
- Inputs: artifact paths + rubric path. **Only the judgment criteria** — the commands already settled the rest.
- The verifier must NOT see the maker's reasoning, conversation, or prior context. Read-only access or a separate worktree.
- Tier per `spawn-economy`: **haiku** for checklist-style judgment, **sonnet** when the assessment is genuinely subtle. Never at or above the maker's tier unless the rubric is judgment-heavy.

Returns the verdict format below — nothing else.

### Step 5 — Act on the verdict

- **MET** — done. Record and continue.
- **NOT MET** — pass **only the gap list** to the maker (continue it via `SendMessage`; do not spawn a fresh maker). No commentary — the maker sees gaps, not the verifier's reasoning. Re-verify by continuing the **same verifier**, not a new one.

### Step 6 — Hard cap at 2 iterations

Still NOT MET after 2 maker iterations → stop. Escalate to the user with the artifact paths, the rubric path, and the remaining gaps verbatim.

Do not self-certify. Do not run a 3rd iteration — two failures means the rubric or the task framing is wrong, and a third pass burns tokens on the same misunderstanding.

---

## Rubric template

Save as `.verify/rubric.md`:

```markdown
# Verification Rubric — <task name>

## Command-answerable (the mechanical gate)

- [ ] `<command>` exits 0
- [ ] `<command>` exits 0

## Judgment-required (model verifier — omit this section if empty)

- [ ] <Criterion — binary, specific, observable>
- [ ] <Criterion>
```

Each criterion answerable "yes" or "no". No partial credit. If a criterion needs judgment, name what counts as passing (e.g. "covers all 5 error cases listed in the task description").

A criterion that could be phrased as a command belongs in the command list — that's free to check.

---

## Verdict format

```
VERDICT: MET
```

or

```
VERDICT: NOT MET

GAPS:
| Criterion                        | Expected                  | Actual                        |
|----------------------------------|---------------------------|-------------------------------|
| All 5 error cases handled        | 5 branches present        | timeout case missing          |
| No auth bypass in handler        | every path checks session | admin route skips check       |
```

No prose. No suggestions. Only the verdict and the gap table.
