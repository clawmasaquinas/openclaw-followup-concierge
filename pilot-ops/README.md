# Pilot Ops

This is the operational layer for delivering the first real OpenClaw Follow-up Concierge pilots.

## What this is for
- creating client workspaces quickly
- keeping delivery consistent
- reducing ad hoc setup during the first few pilots

## Contents
- `new-client.sh` — copies the base pilot template into a new client folder
- `promote-lead.sh` — creates a client workspace and logs it in pilot status
- `clients/` — one folder per pilot client
- `runbooks/` — delivery and operator runbooks

## Recommended flow
1. qualify the lead
2. run discovery call
3. send recap / pilot outline / proposal
4. once they say yes, create or promote the client workspace:
   - `./new-client.sh <client-slug>`
   - or `./promote-lead.sh <client-slug> "Client Name"`
5. fill in client specifics using the intake questionnaire and kickoff brief
6. run the pilot and score it at the end
