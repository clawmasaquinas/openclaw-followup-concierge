# First Pilot Delivery Runbook

A practical sequence for delivering the first real Follow-up Concierge pilot.

## 1. Before kickoff
- confirm pilot scope is narrow
- confirm one primary workflow
- confirm one primary channel
- confirm boundaries and approvals
- confirm success criteria

## 2. Create client workspace
Run:

```bash
./new-client.sh <client-slug>
```

Then fill in:
- `CLIENT.md`
- `CHANNELS.md`
- `WORKFLOWS.md`
- `TONE.md`
- `BOUNDARIES.md`
- `SUCCESS.md`
- `SAMPLES.md`

## 3. Prepare operating memory
Add:
- VIP contacts
- examples of high-priority messages
- examples of low-priority messages
- sample responses in the client's tone
- follow-up timing rules

## 4. Run the pilot daily
Daily operator loop:
- review new inbound examples
- refine priority logic
- tune drafts to client tone
- log false positives / missed items
- keep scope narrow

## 5. End-of-pilot review
Use the scorecard to review:
- response speed
- follow-up consistency
- priority clarity
- operator calm
- workflow usefulness

## 6. Decision
Pick one:
- stop
- continue same workflow
- expand by one adjacent workflow
