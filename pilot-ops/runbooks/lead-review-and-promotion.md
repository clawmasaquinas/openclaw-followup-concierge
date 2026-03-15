# Lead Review and Promotion Runbook

Use this when a lead arrives through the local intake flow.

## 1. Review the lead
Inspect:
- `../data/leads.json`
- or `http://127.0.0.1:8080/api/leads`

Look for:
- clear pain
- obvious fit with Follow-up Concierge
- one likely workflow to start with
- a viable primary channel

## 2. Decide the lead state
- ignore / low fit
- follow up with a qualifying question
- book discovery
- promote into kickoff prep

## 3. Promote a good lead
Run:

```bash
./promote-lead.sh <client-slug> "Client Name"
```

This will:
- create a client workspace from the template
- add a row to `pilot-status.csv`

## 4. Fill the basics
Immediately update the new client folder:
- `CLIENT.md`
- `CHANNELS.md`
- `WORKFLOWS.md`
- `BOUNDARIES.md`
- `SUCCESS.md`

## 5. Move into discovery / proposal / kickoff
Use the existing assets:
- discovery call script
- post-call recap template
- pilot proposal template
- intake questionnaire
- kickoff brief template

## Rule
Do not promote every lead.
Only promote leads that look plausibly close to a real pilot.
