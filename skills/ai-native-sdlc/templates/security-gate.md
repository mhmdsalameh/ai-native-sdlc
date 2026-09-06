# Security gate - <repo>

<!-- A hard pre-ship checklist. Every item must be GREEN (or explicitly risk-accepted by the
client in writing) before a production or client release. In the Deploy stage, do NOT issue the
release authorization (SDLC_RELEASE_AUTH) until this gate passes. Re-run it every release. -->

- **Reviewed by:**   **Date:**   **Release:**
- **Verdict:** pass | pass-with-accepted-risks | blocked

## OWASP Top 10 (2021) - check each
- [ ] **A01 Broken access control** - every route/action checks authorization; no client-side-only gating; no insecure direct object references (users can't reach others' data by changing an id).
- [ ] **A02 Cryptographic failures** - TLS everywhere; passwords hashed (bcrypt/argon2, never plain/MD5/SHA1); secrets not in code; sensitive data encrypted at rest where required.
- [ ] **A03 Injection** - parameterized queries / ORM (no string-built SQL); output encoded to prevent XSS; no shell/command injection from user input.
- [ ] **A04 Insecure design** - abuse cases considered; rate limiting on auth + expensive endpoints; sensible defaults.
- [ ] **A05 Security misconfiguration** - debug off in prod; default creds removed; security headers set (CSP, HSTS, X-Content-Type-Options); directory listing off; least-privilege cloud roles.
- [ ] **A06 Vulnerable / outdated components** - dependency audit clean or triaged (see below).
- [ ] **A07 Auth failures** - strong password policy or SSO; session tokens rotate + expire; lockout/backoff on brute force; MFA where it matters.
- [ ] **A08 Software / data integrity** - dependencies from trusted registries; CI artifacts not tamperable; no unsigned auto-update from untrusted source.
- [ ] **A09 Logging & monitoring failures** - security-relevant events logged (authn, authz failures, admin actions); **no secrets or PII in logs**; alerts wired for anomalies.
- [ ] **A10 SSRF** - server-side fetches validate/allowlist the target; no user-controlled URLs hitting internal services.

## Data & privacy
- [ ] PII/sensitive data inventoried; collected only if needed; retention + deletion path exists.
- [ ] If EU users / payments involved: GDPR / PCI obligations identified and met (or explicitly out of scope in the contract).
- [ ] Backups exist and a restore has been tested.

## Automated checks (run and paste output)
- [ ] **Dependency CVEs:** `npm audit --production` / `pnpm audit` / `pip-audit` / `cargo audit` - clean or every finding triaged.
- [ ] **Secret scan:** scan the repo + git history for keys/tokens (e.g. `gitleaks detect`, `trufflehog`, or `git log -p | grep -iE 'api[_-]?key|secret|password|token'`). Zero leaked secrets.
- [ ] **Static analysis / lint** security rules pass (e.g. `npm run lint`, `bandit`, `semgrep`).
- [ ] Tests green (from the Test stage).

## Secrets & access hygiene
- [ ] No secrets in the repo or client-side bundle; all via env / a secrets manager.
- [ ] Prod credentials are least-privilege and separate from dev/staging.
- [ ] Access to prod is limited and logged.

## Sign-off
Blocking findings must be fixed (back through Build). Accepted risks are listed here with the
client's written acknowledgement before ship.
