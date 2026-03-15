# Deployment Status

## Current public deployment
- **Public site:** https://live-business.vercel.app
- **GitHub repo:** https://github.com/clawmasaquinas/openclaw-followup-concierge

## Hosted features now working
- public marketing homepage
- public pilot request form
- hosted Postgres-backed lead capture
- hosted health endpoint
- protected admin leads endpoint
- Discord lead notifications on submission

## Verified production behaviors
- `GET /api/health` returns OK
- `POST /api/submit` stores leads in Postgres
- successful submission can mark `discord_notified = true`
- `GET /api/leads` works with admin token

## Local operator notes
- admin token is stored locally in `.local-secrets/admin-token.txt`
- runtime/private values are not committed to git

## What still exists locally
The local `site/` and `pilot-ops/` stack still exists and remains useful for:
- local operations
- client workspace generation
- runbooks and pilot delivery support

## Honest current state
The public system is now fully deployed for the first real version.
Future work from here is optimization and expansion, not missing core deployment steps.
