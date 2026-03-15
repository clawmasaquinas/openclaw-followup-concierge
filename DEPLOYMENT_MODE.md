# Deployment Mode

Current public deployment mode is designed for speed, not full backend parity.

## Public host target
- Vercel static deployment from `deploy-static/`

## Why this mode
The richer local stack includes a Node intake backend and local persistence.
That is operationally useful, but not a direct fit for a fast static Vercel launch without adding a proper hosted backend.

## Public/live split
### Public site
- landing page
- request-pilot page
- public-facing proof of offer and positioning

### Local ops stack
- intake backend
- lead storage
- admin/export
- pilot ops tooling

## Next upgrade path
Later, replace the lightweight public intake path with a proper hosted backend or external form handler.
