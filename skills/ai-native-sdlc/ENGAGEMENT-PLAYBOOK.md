# The Engagement Playbook — winning work & delivering with the AI-Native SDLC

`HOW-IT-WORKS.md` is how you **build**. This is how you **win the work, run the client, and hand off
cleanly** — whether you work solo or you're rolling the lifecycle out inside a company.

---

## First: "Does the AI write the FSD for me?" — Yes.

Your **Functional Spec Document is `intent.md` + `spec.md`**, and the AI produces both:

| You want | Command | AI produces | That is your… |
|----------|---------|-------------|---------------|
| Capture the brief | `/sdlc-intent` | `intent.md` — problem, users, outcome, constraints | the requirements brief |
| Turn it into a spec | `/sdlc-spec` | `spec.md` — numbered testable requirements + design + flagged security/compliance/UX concerns | **the FSD** |

You supply the client's answers and **approve**; the AI does the writing. `spec.md` already contains
what an FSD needs: scope, functional requirements, affected users/systems, design, constraints,
acceptance criteria, open questions. If a client wants a formally branded FSD as a deliverable, ask
Claude to render `intent.md` + `spec.md` into a client-facing document — same content, their letterhead.

**You never hand-write an FSD from a blank page again.** You interview, shape, and sign off.

---

## PART 1 — The full engagement, lead → handoff (solo)

👤 = you decide/act &nbsp;&nbsp; 🤖 = the AI does the work

| Phase | 👤 You | 🤖 AI | Artifact / command |
|-------|--------|-------|--------------------|
| **0. Land it** | Find the lead, do a discovery call, qualify fit & budget | — | (sales, see Part 2) |
| **1. Requirements** | Ask the discovery questions (Part 3), take notes | Structures your notes into a brief | `intent.md` · `/sdlc-intent` |
| **2. FSD** | Review the spec against what the client wants; get concerns resolved | Writes requirements + design, flags risks | `spec.md` (the FSD) · `/sdlc-spec` |
| **3. Proposal & contract** | Set scope, price, terms; get a signed agreement + deposit | Drafts scope from the spec | `docs/client/SCOPE.md`, `SUPPORT.md` · `/sdlc-client` |
| **4. Build** | Approve the plan; steer | Plans, then writes the code | `plan.md` + code · `/sdlc-plan` |
| **5. Verify** | Glance — it's already green | Runs tests/build until it passes | tests + evals · `/sdlc-test` |
| **6. Review & demo** | Judge risk; show the client a staging preview | Reviews vs policy; runs the **security gate** | reviewed PR · `/sdlc-review` |
| **7. Launch** | Give the named production authorization | Deploys to staging → prod within gates | `deploy-profile.md` commands |
| **8. Handoff** | Transfer accounts, take final payment, get sign-off | Prepares docs/runbook | `docs/client/HANDOVER.md` |
| **9. Support** | Honor the agreed plan | Watches production, re-files issues | `SUPPORT.md` · `/sdlc-maintain` |

The golden rule holds throughout: **you decide, the AI does, git remembers.** A production problem in
Phase 9 becomes a new `intent.md` and the loop repeats.

---

## PART 2 — Getting clients (where the work actually comes from)

**Position first.** "I build web applications" is invisible. Pick a lane you can prove:
a type of product (dashboards, internal tools, booking systems, browser extensions, MVPs for
founders) or an industry. Your edge is now real: *"I ship production-grade web apps fast, with a
governed process and a security gate — not vibe-coded prototypes."*

**Your proof is your portfolio.** You already have **AutoQC** and the **Auth-Switcher extension**.
For each: a one-line problem, a screenshot/demo, and the outcome. That beats a CV.

**Where to find the work (start with the warm, cheap channels):**
- **Referrals & your network** — highest close rate. Tell everyone what you build; ask for intros.
- **Local businesses** — many need a real web app and have budget; low competition.
- **Freelance platforms** — Upwork, Contra, Toptal (vetted), Fiverr Pro. Slow to start, builds reviews.
- **Communities** — founder/indie-hacker/startup Slacks & Discords, Reddit, X. Be useful, not spammy.
- **Content** — post what you build and *how* (this lifecycle is itself content). Authority → inbound leads.
- **Cold outreach** — targeted, personalized, showing you understand their problem. Volume game.

**The path:** lead → 20-min discovery call → send FSD + proposal → sign + deposit → build.

**Pricing (models, not numbers — the right price depends on value, risk, and your track record):**
- **Fixed price** per well-scoped project — best once you can estimate; protect yourself with a tight `SCOPE.md`.
- **Milestone** — split into paid stages (deposit → each milestone → final on acceptance). Good for larger builds.
- **Hourly / day rate** — for unclear or evolving scope; cap it or convert to fixed once clear.
- Always take a **deposit** (e.g. 30-50%) before building. Ownership transfers on **final payment** (it's in `SUPPORT.md`).
- Undersell scope, over-deliver quality. Everything outside `SCOPE.md` is a **change request**, re-quoted.

---

## PART 3 — Requirements gathering (the discovery call)

This is the one part no AI does for you: **extracting what the client actually needs.** Ask, listen,
then feed the answers to `/sdlc-intent`. A checklist:

**The problem & goal**
- What can't you/your users do today? What does success look like in 3 months?
- Who are the users? How many? What are their roles?
- Is there an existing system this replaces or connects to?

**Scope & features**
- Walk me through the main thing a user will do, start to finish.
- What are the must-haves for launch vs. nice-to-haves for later?
- What is explicitly *out* of scope?

**Data & rules**
- What data does it store? Any personal, payment, or sensitive data? (drives the security gate)
- Any regulations you must meet (GDPR, PCI, HIPAA, industry rules)?

**Look & feel**
- Do you have branding, designs, or examples you like?

**The practical stuff (drives `deploy-profile.md` and the contract)**
- Who hosts it after launch, and who pays for hosting/services?
- Do you have accounts already (domain, payment provider, email)?
- What's the deadline and the budget range?
- Who signs off / who is the decision-maker?
- After launch — do you want a support plan?

Turn the answers into `intent.md`, let the AI produce the FSD, send it back for sign-off **before**
you quote a fixed price. The FSD *is* your scoping tool.

---

## PART 4 — Handoff (what "done" really means for client work)

Never let "it's live" be the end. Run `HANDOVER.md`:
- Transfer the **repo** and all **accounts** into the client's name; then remove your own keys.
- Deliver **secrets via a vault/password manager**, never email or chat.
- Hand over a **fresh database backup** and prove a restore works.
- Include a **README + runbook** (how to deploy, roll back, common issues).
- Attach the passed **security-gate** verdict.
- Get **written acceptance** against `SCOPE.md`, and take **final payment**.
- Record whether they took the **support plan** (`SUPPORT.md`) — and the warranty start date.

A clean handoff is what turns a client into a referral.

---

## PART 5 — Rolling this out at a company

Giving a company "an AI lifecycle" means turning ad-hoc AI use into a **governed, shared system**.
The lifecycle you have is already built for this — here's how to hand it over.

### 1. Distribute the harness (make it shared, not personal)
Right now it lives in *your* `~/.claude` (personal, this machine). For a team it must be **shared and
version-controlled** — that's the whole "skills as institutional knowledge" idea:
- Put the harness (`skills/`, `agents/`, `commands/`, the `hooks/` scripts, `settings.json` hook wiring)
  into a **repo the team installs**, or package it as a **Claude Code plugin** distributed via a company
  marketplace, so everyone gets the same commands, agents, gates, and policy.
- Use **managed settings** for the non-negotiable gates (protected paths, the production gate) so an
  individual can't override them.
- Commit each project's `.sdlc/`, `CLAUDE.md`, `REVIEW.md`, `security-gate.md`, `deploy-profile.md`
  into that project's repo, reviewed like code.

### 2. Map the roles to real people
| SDLC role | Who, in a company | Owns |
|-----------|-------------------|------|
| Product owner | PM / product | approves `intent.md`, `spec.md` |
| Engineer | developer | drives Build, approves routine plans |
| Tech lead / architect | senior eng | approves higher-risk plans, reviews |
| Security / compliance | security team | the policy **skills** + the **security gate** |
| Release manager | lead / ops | the **production authorization** |
| On-call | rota | Maintain-stage triage |

### 3. Pilot, then expand — adopt by pain point
Don't boil the ocean. Pick **one team and one project**, run the full loop, measure it (leading +
lagging indicators are built into each stage), show the result, then roll out. Start at whatever
stage hurts the company most — messy requirements → start at Plan; risky releases → start at the
Deploy gates.

### 4. Encode the company's real policy
The templates are generic. The company's job is to replace them with *their* truth:
- Turn security/brand/compliance standards into **skills** (applied while code is written).
- Turn must-always-hold rules into **hooks** (deterministic blocks).
- Fill `REVIEW.md`, `security-gate.md`, and `deploy-profile.md` with the company's actual checks,
  stack, and commands.

### 5. Train & govern
- Onboard the team with `HOW-IT-WORKS.md` (the plain-English guide) + one live walkthrough of a real feature.
- Governance is automatic: the **commit chain is the audit trail**, the **evals gate** protects config
  changes, and DORA-style metrics come from git/CI. Review the harness like you review code.

### What you hand the company
1. The harness (as a plugin or repo).
2. `HOW-IT-WORKS.md` — how the loop runs.
3. This playbook — how engagements and rollout work.
4. A 60-minute walkthrough building one real feature end-to-end.

---

## One-page checklist per engagement

```
[ ] Discovery call done (Part 3 questions answered)
[ ] intent.md written & client-confirmed        (/sdlc-intent)
[ ] spec.md / FSD written & signed off          (/sdlc-spec)
[ ] SCOPE.md + SUPPORT.md agreed, deposit paid   (/sdlc-client)
[ ] plan.md approved, built                      (/sdlc-plan)
[ ] tests green                                  (/sdlc-test)
[ ] review passed + security gate green          (/sdlc-review)
[ ] deployed to prod with authorization          (deploy-profile.md)
[ ] HANDOVER.md complete, final payment, sign-off
[ ] support plan recorded / maintenance running  (/sdlc-maintain)
```

**Remember:** the AI writes the FSD, the code, the tests, and the docs. You own the *relationship*
and the *judgment* — the discovery, the scope, the sign-offs, and standing behind what ships.
