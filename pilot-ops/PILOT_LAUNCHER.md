# Pilot Launcher

## Goal
Turn a hosted lead into a ready-to-work pilot workspace in one command.

## Commands
### List hosted leads
```bash
./list-hosted-leads.sh
```

### Launch a pilot from a hosted lead
```bash
./launch-pilot.sh <lead-id> <client-slug>
```

Example:
```bash
./launch-pilot.sh 2 acme-followup
```

## What launch-pilot.sh does
- fetches the hosted lead from `https://live-business.vercel.app/api/leads`
- creates `pilot-ops/clients/<client-slug>/`
- prefills core client files from the lead
- generates `KICKOFF-BRIEF.md`
- generates `INTAKE-SNAPSHOT.md`
- generates operational working files like `DAILY-CHECKLIST.md`, `LEAD-QUEUE.md`, `DRAFTS.md`, and `TRIAGE-RULES.md`
- updates `pilot-status.csv`

## What it does not do yet
- connect a live inbox automatically
- pull real message history from the client
- infer tone from existing communications automatically
- start autonomous follow-up without human review

## Immediate next step after launch
Collect real message examples and tone samples, then run the pilot using the generated workspace.
