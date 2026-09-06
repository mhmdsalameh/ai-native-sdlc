# Deploy profile - <repo>

<!-- Pick these once per project and reuse them. This is what makes "Deploy" and "Maintain" real
instead of aspirational: the Deploy stage reads the commands and tiers from here. Fill every field. -->

## Stack
- **Hosting / platform:** <e.g. Vercel / Netlify / Fly.io / Railway / AWS ECS / a VPS>
- **Runtime:** <node 20 / python 3.12 / ...>
- **Database:** <Postgres (Supabase/Neon/RDS) / SQLite / ...>  **Backups:** <cadence + where>
- **Domain & TLS:** <domain, DNS provider, auto-TLS?>
- **Secrets manager:** <platform env vars / Doppler / Vault / 1Password> - never in the repo.

## Environments (tiers the Deploy gate uses)
| Env | Branch | URL | Who can deploy |
|-----|--------|-----|----------------|
| development | <dev> | <local/preview> | agent (free) |
| staging | <staging> | <url> | agent, with logged approval |
| production | <main> | <url> | **agent prepares; named human authorizes** |

## Commands (exact, copy-pasteable)
- **Build:** `<...>`
- **Test:** `<...>`
- **Deploy staging:** `<...>`
- **Deploy production:** `<...>`  (matches a `prod_gate_command_patterns` entry in `.sdlc/config.yaml`)
- **Rollback:** `<single proven command>`  - the most-rehearsed path; exercise it in staging regularly.
- **DB migrate:** `<...>`  **Migrate rollback:** `<...>`

## CI/CD
- **CI provider:** <GitHub Actions / ...>  **Pipeline file:** <path>
- Agent write-steps arrive as **PRs through branch protection** - no direct push to prod.
- CI jobs run with **short-lived, scoped tokens**; no standing production credentials.

## Monitoring & alerting (feeds the Maintain stage)
- **Metrics/APM:** <e.g. platform metrics / Sentry / Grafana>
- **Uptime check:** <provider + URL>
- **Key metrics watched (bands.yaml):** <e.g. post-deploy 5xx rate, p95 latency, error rate>
- **On-call / alert channel:** <Slack channel / email>

## Notes
Rollback must be proven before Maintain needs it. If a control band breaches at 3sigma, this is the
command it runs.
