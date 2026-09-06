# How the AI-Native SDLC Works — a plain-English guide

This is how a project gets built here: not one prompt and one answer, but a **loop of six steps**.
At every step you make the decisions; the AI does the work; and each step ends by **saving a file to
git** so there's a permanent record of what was decided and why.

Two roles run through the whole thing:

- 👤 **You (the human)** — you own judgment. You approve, correct, and decide when to move on.
- 🤖 **The AI** — it does the labor: writing, coding, testing, reviewing. It stops and asks whenever
  a real decision is yours.

**The golden rule:** the AI can do everything *up to* a gate. It cannot walk through a gate — only you can.

---

## Step 0 — Set up the repo (once per project)

**Command:** `/sdlc-init`

- 👤 **You do:** Run it once in a new project. Afterwards, fill in a couple of blanks it leaves
  (which files are off-limits, what counts as a "production deploy").
- 🤖 **The AI does:** Creates the starter files the workflow needs — the config, the review rules,
  the monitoring config, and the guardrails that block dangerous edits.
- **What's happening:** You're laying down the rails. After this, every later step has a place to
  put its work and a set of rules to follow.

---

## Step 1 — PLAN — "What do we actually want?"

**Command:** `/sdlc-intent` → produces **`intent.md`**

- 👤 **You do:** Describe the idea in plain words — the problem, who it's for, and any hard limits.
  Answer the AI's questions. When it's right, approve it.
- 🤖 **The AI does:** Interviews you like a good analyst would, then writes it all up as `intent.md`
  (the problem, the desired outcome, who's affected, constraints, open questions) and saves it.
- **What's happening:** You're capturing *what* and *why* — never *how*. No solutions yet. This
  replaces weeks of meetings and tickets with a single, clear, written intent.
- 🚦 **Gate:** You (the product owner) approve the intent before moving on.

---

## Step 2 — DESIGN — "How should we build it?"

**Command:** `/sdlc-spec` → produces **`spec.md`**

- 👤 **You do:** Read the spec against your original idea — does it actually solve the problem? If the
  AI flags a security, compliance, or brand concern, get the right person to resolve it. Then approve.
- 🤖 **The AI does:** Turns `intent.md` into a real specification — testable requirements plus a
  design — while automatically checking it against your policies, and **flags anything that conflicts**.
- **What's happening:** Requirements and design happen together, in one pass, with policy applied
  *as it's written* — so problems get caught now, not in a review three weeks later.
- 🚦 **Gate:** Flagged concerns resolved, and you approve moving to Build.

---

## Step 3 — BUILD — "Write the code — but plan first."

**Command:** `/sdlc-plan` → produces **`plan.md`**, then the code

- 👤 **You do:** Read the AI's plan and poke holes in it — what could break? Any better approach? When
  the plan is solid enough that a stranger could follow it, approve it. Then let it build.
- 🤖 **The AI does:** First goes into **plan mode** — it reads the whole codebase but is **not allowed
  to change a single file yet**. It writes a plan (which files, in what order, which tests). Only after
  you approve does it write the code, usually in one clean pass.
- **What's happening:** The argument happens on the *plan*, where changing your mind is free — not on
  finished code, where it's expensive. This is the single biggest quality lever.
- 🚦 **Gate:** Plan approved **before** any file is edited. (The system enforces this — it literally
  can't edit until you say go.)

---

## Step 4 — TEST — "Prove it works before I even look."

**Command:** `/sdlc-test` → produces tests + **evals**

- 👤 **You do:** Very little. Glance at the result. The point of this step is that the AI has already
  checked its own work, so you're reviewing something that already passes.
- 🤖 **The AI does:** Runs the tests / build / screenshot, and if something fails, **fixes it and runs
  again** — looping until it's green, *before* you see it. For bug fixes it writes the failing test
  first, then fixes the code (it's blocked from "fixing" the test to cheat).
- **What's happening:** The AI gets a scoreboard it can't argue with. It arrives at your desk already
  de-risked. "Evals" are a saved set of real tasks that get re-run whenever the setup changes, so the
  AI itself never quietly regresses.
- 🚦 **Gate:** Verification is green and counts as part of "done".

---

## Step 5 — DEPLOY — "Review it, then ship it behind gates."

**Command:** `/sdlc-review` → produces a **reviewed PR**

- 👤 **You do:** Focus only on intent and risk — is this the right change, and is the risk acceptable?
  Give the final sign-off. For anything going to **production**, you (or the release manager) give the
  explicit go-ahead.
- 🤖 **The AI does:** Reviews the change against your `REVIEW.md` rules (bugs, security, compliance),
  ranks the findings, and fixes what you tag it on. It can prepare a release and deploy to dev/staging
  — but it **stops dead at the production gate**.
- **What's happening:** Every change gets the same thorough review pass, so your attention goes to
  judgment, not nitpicking. A rule enforces **separation of duties**: the AI that wrote the code can't
  approve it. Before anything goes to production or a client, the **security gate** (`security-gate.md`
  — OWASP Top 10, dependency audit, secret scan) must pass; production always needs a named human
  authorization, and deploy/rollback use the exact commands in `deploy-profile.md`.
- 🚦 **Gate:** Security gate green; human sign-off to merge; a named human authorization to reach production.

---

## Step 6 — MAINTAIN — "Watch production, and feed problems back in."

**Command:** `/sdlc-maintain` → produces a new **`intent.md`** (loops back to Step 1)

- 👤 **You do:** Triage what the AI surfaces — schedule the fix, or send a product-facing finding to
  the right owner. Dismiss noise (which teaches the system to be quieter next time).
- 🤖 **The AI does:** A plain, deterministic script watches your key metrics. When one drifts out of
  its safe band, it wakes the AI to **diagnose** (read-only at first; allowed to open a fix PR only at
  the highest severity). It writes up what it found as a **new `intent.md`** — which re-enters Step 1.
- **What's happening:** This is what **closes the loop**. A production problem doesn't sit in a ticket
  queue — it becomes a new intent and flows right back through Design → Build → Test → Deploy. Each
  incident also becomes a permanent eval, so the same class of problem can't come back silently.
- 🚦 **Gate:** On-call triages; any fix still goes through the Step 5 review gate.

---

## The whole thing at a glance

```
        ┌──────────────────────────────────────────────────────────┐
        │                     the loop never ends                   │
        ▼                                                           │
  1 PLAN ──intent.md──▶ 2 DESIGN ──spec.md──▶ 3 BUILD ──plan.md──▶ 4 TEST
                                                                    │
                                                          code+tests│
                                                                    ▼
        6 MAINTAIN ◀──deploy record── 5 DEPLOY ◀──────────reviewed PR
             │
             └────────── incident → new intent.md ──────────▶ (back to PLAN)
```

| Step | Command | You (human) | The AI | Saved artifact |
|------|---------|-------------|--------|----------------|
| 0 · Setup | `/sdlc-init` | run once, fill blanks | scaffolds the rails | config + guardrails |
| 1 · Plan | `/sdlc-intent` | describe & approve the idea | interviews you, writes it up | `intent.md` |
| 2 · Design | `/sdlc-spec` | resolve concerns, approve | spec + design, flags policy | `spec.md` |
| 3 · Build | `/sdlc-plan` | approve the plan | plans first, then codes | `plan.md` + code |
| 4 · Test | `/sdlc-test` | glance | self-checks until green | tests + evals |
| 5 · Deploy | `/sdlc-review` | judge risk, authorize prod | reviews, ships to the gate | reviewed PR |
| 6 · Maintain | `/sdlc-maintain` | triage findings | watches, diagnoses, re-files | incident `intent.md` |

**One line to remember:** *You decide, the AI does, git remembers — and production problems come back
around as the next thing to build.*
