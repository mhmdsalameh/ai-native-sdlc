---
description: Scaffold the client-engagement pack for a client web-app project - scope of work, support/maintenance terms, and a handover checklist - into docs/client/. Idempotent; never overwrites. Use when taking on a paid client build.
argument-hint: [client name]
---

# /sdlc-client - scaffold the client engagement pack

Templates live in `~/.claude/skills/ai-native-sdlc/templates/client/`. For paid client work, run this
alongside `/sdlc-init`.

## Steps
1. Confirm this is a git repo. Create `docs/client/` if missing.
2. For each target, create it from the template **only if it does not already exist** (never overwrite; report created vs. skipped):
   - `docs/client/SCOPE.md`    <- `templates/client/SCOPE.md`
   - `docs/client/SUPPORT.md`  <- `templates/client/SUPPORT.md`
   - `docs/client/HANDOVER.md` <- `templates/client/HANDOVER.md`
3. Fill in the client name / date where `$ARGUMENTS` gives it; leave the commercial blanks for the user.
4. Remind the user: these align expectations and are **not a substitute for a lawyer-reviewed contract** - agree the scope here, then have the legal terms drawn up.
5. Commit: `chore: add client engagement pack`.

Then run the normal loop (`/sdlc-intent` ...). At Deploy, the **security gate** must pass and the
`HANDOVER.md` checklist must be complete before final delivery. Use the Write tool for each file; never script file creation.
