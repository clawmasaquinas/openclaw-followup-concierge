# Live Business Buildout

This directory contains the production-facing local assets for turning the OpenClaw monetization work into something operational.

## Structure
- `site/` — landing page, intake backend, admin view, and service scripts
- `pilot-ops/` — pilot delivery scaffolding, client workspace creation, and operational runbooks
- `data/` — captured lead data
- `status.sh` / `start-all.sh` — top-level operator commands

## Immediate local usage
### Start the full local stack
From `live-business/`:
- run `./start-all.sh`
- then inspect with `./status.sh`

### Create a new pilot workspace
From `pilot-ops/`:
- run `./new-client.sh <client-slug>`

Example:
- `./new-client.sh northshore-web-studio`

This creates a client-ready workspace under `pilot-ops/clients/<client-slug>/` from the pilot template.

## Intent
These assets are local-first and production-oriented.
They are now usable as a real local intake + pilot-ops stack.
Public launch and outward-facing customer acquisition still require external deployment and outreach.
