---
description: Generate or update a CODEMAP.md navigation index — domain map, entry points, line references, and function dependency index
argument-hint: [update [file...]] | [output-path]
---

# Codemap Generator / Updater

Two modes depending on `$ARGUMENTS`:

- **No args or a file path** → full generation (see Generation mode below)
- **`update`** or **`update <file1> <file2> ...`** → targeted refresh (see Update mode below)

> **Cost note:** full generation greps every key function across the codebase and is the most expensive command here. If `CODEMAP.md` already exists, default to **update mode** — say so and ask before doing a full rebuild. Never spawn a subagent to build the map: it would have to re-read the same files you can read directly, and the map is a write-once artifact, not a research task.

---

# Update Mode  (`update [file...]`)

Use this after editing code to keep CODEMAP.md accurate without regenerating everything.

## U1 — Determine what changed

If file paths were provided after `update`, use those.  
Otherwise read `.codemap-dirty` (one absolute or repo-relative path per line) for the list.  
If neither exists, ask the user which files changed.

## U2 — For each changed file

Open the file and the current CODEMAP.md.

**Domain section update:**
- Find the file's rows in the domain tables
- Re-read the file to confirm current line numbers for each listed symbol
- Update any line numbers that shifted
- If a listed symbol was deleted, remove its row and note `(removed)` inline
- If a new exported function/class was added, add a new row for it

**Dependency index update:**  
For every function in the file that appears in the Function Dependency Index:

1. Check if the function still exists at that line — if deleted, mark the entry `(removed — check callers)` and list its former callers so they can be fixed
2. If the function signature changed (params, return type), update the entry and re-grep for all callers to confirm the list is still accurate
3. If new internal calls were added to the function body, append them to **Calls**
4. If the function is new and exported, add a full entry: grep for callers, read body for callees, assess impact level

## U3 — Cross-check callers of changed functions

For any function whose signature or return shape changed:

```
Grep the whole codebase for the function name
```

Compare results against the **Called by** list. Add any new callers, remove any that no longer exist.

## U4 — Clear the dirty list

After processing, delete `.codemap-dirty` (or truncate it to empty).

## U5 — Report

List every entry that was updated, added, or removed. Flag any `(removed)` entries whose callers need attention — name the caller files explicitly.

---

# Generation Mode  (full build)

Generate a fresh `CODEMAP.md` for the current project. Output goes to `$ARGUMENTS` if it looks like a path, otherwise `CODEMAP.md` in the project root.

## Step 1 — Scope the project

Glob the top 3 directory levels. Count source files, identify languages/frameworks, note the project root.

If fewer than ~30 source files: say so and ask if the user still wants the map.

## Step 2 — Identify domain areas

Read the top-level directory structure. Group source files into 4-12 logical domains:

- By directory (`src/auth/`, `src/api/`, `src/db/`)
- By feature (auth, billing, notifications, admin)
- By layer (routes, services, models, utils)

If a README, architecture doc, or CLAUDE.md exists, read it first — it may already name the domains.

## Step 3 — Map entry points and key symbols

For each domain, find:
- **Entry point**: first-imported file (router, index, main class)
- **Key exports**: functions, classes, constants other files depend on

Record the exact `file:line` for each. Prioritize `index.*`, `main.*`, `app.*`, `server.*`, and files appearing in many imports.

## Step 4 — Find cross-cutting concerns

Identify files used everywhere that don't belong to one domain:
- Config / environment loading
- Database connection / ORM setup
- Logging / error handling middleware
- Shared types / interfaces / constants
- Test utilities / fixtures

List these as **Shared / Infrastructure**.

## Step 5 — Build the function dependency index

For every **key function** from Steps 3-4 (exported functions, public methods, route handlers, shared utilities):

**Callers** — grep for the function name across the whole codebase; record each call site as `file:line`.

**Callees** — read the function body; list significant internal calls (other project functions, not stdlib/framework primitives).

**Impact level:**
- `critical` — called in 5+ places or on a hot path (middleware, request handler, event loop)
- `high` — called in 2-4 places
- `low` — called in 1 place or only in tests

**Side effects** — note: DB write, cache invalidation, event emission, or `none`.

Skip trivial getters, pure constants, and single-caller one-liners. If more than ~40 key functions exist, generate a companion `DEPMAP.md` and link to it from CODEMAP.md instead of embedding.

## Step 6 — Write CODEMAP.md

```markdown
# Code Navigation Map

> Generated: <DATE>. Re-run `/codemap` for full rebuild, or `/codemap update <file>` after edits.
> Stale entries are tracked in `.codemap-dirty` — run `/codemap update` to patch them.

## Project Overview

<2-3 sentences: what this project does, tech stack, rough size (X files, ~Y KLOC)>

## How to use this map

- **Finding code**: Go to the relevant domain section → `file:line` → open directly.
- **Before editing a function**: Read its entry in the [Function Dependency Index](#function-dependency-index) to see what callers will be affected.
- **After editing**: Run `/codemap update <changed-file>` to keep the map accurate.

---

## Domains

### <Domain Name>

> <1-sentence description>

| File | Line | What it is |
|------|------|------------|
| `src/auth/index.ts` | 1 | Entry point, exports auth middleware |
| `src/auth/jwt.ts` | 45 | `verifyToken()` — validates JWT, extracts claims |
| `src/auth/models/User.ts` | 12 | `User` model — fields, validations, DB mapping |

*(repeat per domain)*

---

## Shared / Infrastructure

| File | Line | What it is |
|------|------|------------|
| `src/config.ts` | 1 | Env var loading, all config values exported |
| `src/db/index.ts` | 1 | DB connection pool, `query()` helper |
| `src/logger.ts` | 1 | Structured logger, log levels |

---

## Entry Points

| How the app starts | File | Line |
|-------------------|------|------|
| HTTP server | `src/server.ts` | 1 |
| CLI | `bin/cli.ts` | 1 |
| Background worker | `src/workers/index.ts` | 1 |

---

## Key Data Models / Types

> Read these when confused about data shapes — types here ripple everywhere.

| File | Type/Interface | Line |
|------|---------------|------|
| `src/types/User.ts` | `User`, `UserRole` | 1 |
| `src/types/Order.ts` | `Order`, `OrderStatus` | 1 |

---

## Function Dependency Index

> Before changing any function below, read its entry to know what will break.
> After changing, run `/codemap update <file>` to refresh the entry.

### Auth

#### `verifyToken(token: string): User`
- **Defined**: `src/auth/jwt.ts:45`
- **Impact**: critical
- **Called by**:
  - `authMiddleware` — `src/auth/middleware.ts:12`
  - `refreshToken` — `src/auth/refresh.ts:30`
  - `wsAuthHandler` — `src/ws/auth.ts:8`
- **Calls**:
  - `jwt.verify` (external lib)
  - `UserModel.findById` — `src/models/User.ts:89`
- **Side effects**: none (read-only)
- **Change note**: Changing return shape breaks all three callers. Signature change requires updating middleware type annotations.

*(repeat per function, grouped by domain)*
```

Only include rows where you verified the file and line exist. Mark uncertain entries `(unverified)`. Do not invent.

## Step 7 — Report

- Path of generated file(s)
- Domains found and functions indexed
- `critical`-impact functions — name them explicitly
- Areas skipped (generated code, vendored dirs, test fixtures)
