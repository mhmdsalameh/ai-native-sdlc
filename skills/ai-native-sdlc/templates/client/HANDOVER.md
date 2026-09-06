# Handover checklist - <client> / <project>

<!-- Complete at delivery. A clean handover protects both sides and is what "done" really means for
client work. Check every item; note where each thing lives. -->

- **Delivered by:** @mhmdsalameh   **To:**   **Date:**   **Final payment received:** yes / no

## Code & repository
- [ ] Source repository transferred to the client's account/org (or access granted).
- [ ] `README.md` explains setup, build, test, and run.
- [ ] `CLAUDE.md` / architecture notes / `CODEMAP.md` included.
- [ ] A short runbook: how to deploy, how to roll back, common issues.

## Access & credentials (transfer, then rotate off your own accounts)
- [ ] Hosting/platform account or access.
- [ ] Domain & DNS control.
- [ ] Database access + a fresh backup handed over.
- [ ] Environment variables / secrets delivered securely (a vault or password manager, **not** email/chat).
- [ ] Third-party service accounts (payment, email, analytics, storage) in the client's name.
- [ ] Monitoring / error-tracking access.
- [ ] Any of *your* keys removed from their systems after transfer.

## Verification
- [ ] Security gate passed for the shipped release (attach `security-gate.md` verdict).
- [ ] Acceptance criteria in `SCOPE.md` met and signed off by the client.
- [ ] Backups verified by a test restore.
- [ ] Client walked through the app + runbook (recording or notes attached).

## Sign-off
- **Client acceptance:** name / date - confirms deliverables received and working.
- **Support plan:** SUPPORT.md agreed (warranty start date recorded), or declined in writing.
