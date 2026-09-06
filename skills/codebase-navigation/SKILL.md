---
name: codebase-navigation
description: Create and maintain CODEMAP.md, plus deep codebase navigation. Use at the START of every new project to seed the map (mandatory scaffold, alongside STATE.md), and when working in a large or unfamiliar codebase — read the map before exploring, check a function's dependency index before changing it, and update CODEMAP.md after edits.
---

# Codebase Navigation

<!-- Related skill: `codebase-orientation` (terser orient-first version attached to subagents). This is the deeper on-demand reference. Keep guidance consistent across both. -->

## At the start of any session in a large project

1. Look for `CODEMAP.md` or `.claude/CODEMAP.md` in the project root
2. If found, read it before doing any Glob/Grep exploration
3. Check for `.codemap-dirty` — if it exists and has content, run `/codemap update` before starting work so the map reflects the latest state
4. If no map exists and the project is large (many directories, unclear structure), suggest running `/codemap` to generate one

## When starting a NEW project (greenfield)

Do not wait until the project is "large enough" — by then the map is archaeology instead of bookkeeping.

- Create `CODEMAP.md` **at project start, before the first implementation** — as part of the
  initial scaffold, alongside `STATE.md`. Seed it with the project name, a `## Entry points`
  heading, a `## Domains` table, and a `## Function Dependency Index` heading, even if the
  sections are empty. A stub with the right headings is the point: the next write is an
  append, not a decision about whether to start one.
- Fill it in as code lands: entry points, a domain table per directory, and key functions with
  `file:line` refs.
- From then on, the per-feature loop is: implement → verify → **update CODEMAP.md for every file created or changed** → commit (map in the same commit as the code it describes).
- A feature is not "done" — not in FEATURES.json, not in the pipeline — until the map reflects it. Same discipline as the verify command.

### Seed template

Copy verbatim at project start. Empty sections are expected on day one.

```markdown
# CODEMAP.md — <project name>

<!-- Where code lives and what depends on what. Update in the same commit as the code. -->

## Entry points
<!-- Format: - `<path>` — <what starts here> -->

## Domains
<!-- One table per top-level directory. -->
<!--
### src/<domain>
| File | Responsibility | Key symbols (file:line) |
|------|----------------|-------------------------|
-->

## Function Dependency Index
<!-- Format:
### `<name>` — `<file>:<line>`
- Calls: <callees>
- Called by: <callers>
- Impact: critical | high | low
- Side effects: <DB write, event, cache, none>
-->

## Conventions
<!-- Project-wide patterns a newcomer would get wrong. Module-local rules go in that module's CLAUDE.md. -->
```

## When a CODEMAP.md exists — navigating

- Use it as the primary reference for "which file handles X?"
- Navigate directly to the `file:line` references it provides — do not scan blind
- If a task touches a domain in the map, open only those domain files first

## Before modifying any function

Find the function's entry in the **Function Dependency Index** (in CODEMAP.md or DEPMAP.md):

1. Read **Called by** — every listed file is a potential breakage point; check each after your change
2. Read **Calls** — if you change what this function calls, trace the effect downward too
3. Respect the **Impact** level:
   - `critical` — verify all callers still compile and behave correctly
   - `high` — check each caller for broken assumptions
   - `low` — spot-check the single caller
4. Note **Side effects** — a signature-compatible change can still break callers that depend on a side effect (DB write, event emission, cache state)

If the function is not in the index, grep its name across the codebase before changing its signature or return shape.

## After modifying any file

If a CODEMAP.md exists in the project, update it immediately — do not defer:

1. **Line numbers** — if lines shifted, update the row for that file in its domain table
2. **Changed function signature or return type** — update the dependency entry; re-grep callers to confirm the list is still correct
3. **Deleted function** — mark its entry `(removed — check callers)` and name the former callers explicitly so nothing silently breaks
4. **New exported function** — add a row to the domain table and a full dependency entry (grep for callers, read body for callees, assign impact level)
5. **Extensive changes** (multiple functions added/removed, file restructured) — run `/codemap update <file>` rather than patching by hand

If the update would take more than a few edits, run `/codemap update <changed-file>` and let the command handle it.

Write the changed file path to `.codemap-dirty` only if you were unable to update CODEMAP.md inline — this flags it for the next session.

## CODEMAP.md is a living document, not a snapshot

- It tells you *where* code lives and *what depends on what* — read the actual files to understand behavior
- An entry that doesn't match what you see in the file is stale — fix it, don't trust it
- If the map has drifted badly from reality, run `/codemap` for a full rebuild

## When no CODEMAP.md exists

- Small projects (< ~30 files): explore normally with Glob/Grep
- Large projects: suggest `/codemap` when exploration takes more than 2-3 orientation rounds
- Always grep for a function's name before changing its signature — never edit blind

## Per-module CLAUDE.md / AGENT.md files

The codebase is the documentation. If a convention, constraint, or "how we do things here" isn't written into the repo, the agent won't know about it next session.

- **Where they live**: one onboarding file per major module, not just one at the root. A large repo should have a root `CLAUDE.md` (project-wide context) plus a `CLAUDE.md` in each significant module (`src/auth/`, `src/billing/`, etc.) describing that module's local conventions, gotchas, and what's in progress.
- **What goes in them**: local architecture decisions, naming/pattern conventions specific to that area, non-obvious constraints, and current work-in-progress. Keep them short — a map, not a manual.
- **Read them on entry**: before working in a module, read that module's `CLAUDE.md`/`AGENT.md` (the session-startup routine covers this).
- **Keep them current**: when you change a convention or finish in-progress work described in a module's file, update that file in the same session — same discipline as CODEMAP. A stale onboarding doc actively misleads the next session.
- **Don't over-create**: only add a module file when that module has real local rules a newcomer would get wrong. An empty or generic file is noise.
