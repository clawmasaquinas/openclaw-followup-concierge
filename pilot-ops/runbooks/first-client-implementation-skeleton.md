# First Client Implementation Skeleton

This is the minimum concrete shape for a real first Follow-up Concierge pilot.

## Recommended first use case
### Workflow
New inbound lead triage + stale follow-up reminders

### Primary channel
Email first

### Why this is the best first implementation
- easiest to explain
- easiest to evaluate
- highest chance of obvious ROI
- least risky relative to autonomous actions

## Minimum client data needed
- 5 examples of high-priority messages
- 5 examples of low-priority or noisy messages
- 3 examples of replies in the client’s tone
- stale threshold (e.g. 3 business days)
- list of VIP senders / domains
- explicit off-limits topics or actions

## Minimum daily output
Generate one daily operating view with:
- urgent messages to review first
- warm leads that need a nudge
- suggested reply drafts
- anything safely ignorable

## Minimum decision rules
### Mark urgent if:
- explicit buying intent
- referral source mentioned
- quote or proposal request
- time-sensitive language
- VIP sender

### Mark stale follow-up if:
- warm thread has no reply after the agreed threshold
- proposal or estimate was sent and no response arrived

### Mark low priority if:
- receipts
- billing notices
- newsletters
- automated notifications
- resolved threads

## Human approval rule
Default mode for first client:
- drafts only
- reminders only
- summaries only
- no autonomous external sending

## Success test after 7–14 days
The implementation passes if the client says some version of:
- “I’m answering the right things faster.”
- “I’m missing less.”
- “This actually lowers my inbox stress.”

## Failure signs
- too many false positives
- drafts feel off-tone repeatedly
- reminders are noisy
- scope spread beyond one workflow

## If successful
Expand in this order:
1. same workflow, better tuning
2. second message channel
3. one adjacent workflow
