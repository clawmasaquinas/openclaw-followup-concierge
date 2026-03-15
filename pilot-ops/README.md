# Pilot Ops

This is the operational layer for delivering the first real OpenClaw Follow-up Concierge pilots.

## What this is for
- creating client workspaces quickly
- keeping delivery consistent
- reducing ad hoc setup during the first few pilots

## Contents
- `new-client.sh` — copies the base pilot template into a new client folder
- `promote-lead.sh` — creates a client workspace and logs it in pilot status
- `list-hosted-leads.sh` — shows leads captured by the hosted production app
- `launch-pilot.sh` — turns a hosted lead into a prefilled pilot workspace
- `clients/` — one folder per pilot client
- `runbooks/` — delivery and operator runbooks
- `PILOT_LAUNCHER.md` — launcher usage notes

## Recommended flow
1. qualify the lead
2. run discovery call
3. send recap / pilot outline / proposal
4. once they say yes, launch the client workspace from the hosted lead:
   - `./list-hosted-leads.sh`
   - `./launch-pilot.sh <lead-id> <client-slug>`
5. review and refine the generated client files with real examples
6. run the pilot using the generated operational files (`DAILY-CHECKLIST.md`, `LEAD-QUEUE.md`, `DRAFTS.md`, `TRIAGE-RULES.md`)
7. score it at the end
