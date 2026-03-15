#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <lead-id> <client-slug>"
  exit 1
fi

LEAD_ID="$1"
SLUG="$2"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
WORKSPACE_ROOT="$(cd -- "$ROOT/.." && pwd)"
CLIENTS_DIR="$SCRIPT_DIR/clients"
CLIENT_DIR="$CLIENTS_DIR/$SLUG"
STATUS_CSV="$SCRIPT_DIR/pilot-status.csv"
ADMIN_TOKEN_FILE="$ROOT/.local-secrets/admin-token.txt"
TMP_JSON="$(mktemp)"

cleanup() {
  rm -f "$TMP_JSON"
}
trap cleanup EXIT

if [[ ! -f "$ADMIN_TOKEN_FILE" ]]; then
  echo "Admin token file missing: $ADMIN_TOKEN_FILE"
  exit 1
fi

ADMIN_TOKEN="$(cat "$ADMIN_TOKEN_FILE")"

curl -fsS -H "x-admin-token: $ADMIN_TOKEN" https://live-business.vercel.app/api/leads > "$TMP_JSON"

python3 - <<'PY' "$TMP_JSON" "$LEAD_ID" "$SLUG" "$SCRIPT_DIR" "$ROOT" "$WORKSPACE_ROOT"
import json, sys, pathlib, re
json_path, lead_id, slug, script_dir, root, workspace_root = sys.argv[1:7]
lead_id = int(lead_id)
data = json.loads(pathlib.Path(json_path).read_text())
lead = next((x for x in data.get('leads', []) if int(x.get('id')) == lead_id), None)
if not lead:
    raise SystemExit(f'Lead id {lead_id} not found in hosted leads API')

script_dir = pathlib.Path(script_dir)
root = pathlib.Path(root)
workspace_root = pathlib.Path(workspace_root)
client_dir = script_dir / 'clients' / slug
client_dir.mkdir(parents=True, exist_ok=True)

def write(name, content):
    (client_dir / name).write_text(content)

name = lead.get('name') or slug
business = lead.get('business') or name
email = lead.get('email') or ''
website = lead.get('website') or ''
contact_channel = lead.get('contact_channel') or 'email'
primary_channel = lead.get('primary_channel') or 'email'
problem = lead.get('problem') or 'Follow-up inconsistency'
win = lead.get('win') or 'Faster replies and fewer dropped opportunities'

def title_case_slug(s):
    return re.sub(r'[-_]+', ' ', s).title()

client_display = business or title_case_slug(slug)

readme = f'''# {slug}

Client pilot workspace launched from hosted lead #{lead_id}.

## Launch summary
- Lead id: {lead_id}
- Name: {name}
- Business: {business}
- Email: {email}
- Primary channel: {primary_channel}

## Immediate next steps
1. Review CLIENT.md
2. Review CHANNELS.md
3. Review WORKFLOWS.md
4. Review TONE.md
5. Review BOUNDARIES.md
6. Review SUCCESS.md
7. Expand SAMPLES.md with real examples from the client
8. Use LOG.md as the running pilot log
'''

client_md = f'''# CLIENT.md

## Client
- Name: {name}
- Business: {business}
- Email: {email}
- Website: {website or 'TBD'}
- Preferred contact channel: {contact_channel}
- Primary pain: {problem}

## Pilot goal
{win}

## First workflow to prove
- New inbound lead triage
- Stale follow-up reminders
'''

channels_md = f'''# CHANNELS.md

## Primary channel
- {primary_channel}

## Contact preference
- {contact_channel}

## Intake model
- default recommendation: forwarded lead emails or shared lead inbox
- current known primary channel: {primary_channel}

## Rule
Start with one primary channel before adding another.
Avoid broad inbox access by default.
'''

workflows_md = f'''# WORKFLOWS.md

## Workflow 1
- Name: New inbound lead triage
- Trigger: New inbound message in the primary client channel
- Desired outcome: Important inquiries are surfaced quickly and drafted for review
- Human approval required?: Yes
- Escalation rule: Escalate urgent/VIP/time-sensitive inquiries immediately

## Workflow 2
- Name: Stale follow-up reminder
- Trigger: Warm conversation has no reply after the agreed threshold
- Desired outcome: Client receives a reminder and optional follow-up draft
- Human approval required?: Yes
- Escalation rule: Escalate proposal/quote threads and VIP contacts first

## Why this fits now
- Current stated pain: {problem}
- Desired win: {win}

## Rule
Start with one narrow workflow if possible.
'''

success_md = f'''# SUCCESS.md

## Success criteria
- Faster response to important inbound
- Fewer warm threads going stale
- Cleaner daily priority view
- Lower operator stress around follow-up
- Specific client win: {win}

## End-of-pilot question
Would the client miss this workflow if it disappeared tomorrow?
'''

tone_md = f'''# TONE.md

## Current known guidance
- Preferred contact channel: {contact_channel}
- We still need real reply examples from the client

## Initial default
- warm
- clear
- practical
- concise

## To collect
- 2–3 example replies that sound like the client
- any phrases or tones to avoid
'''

boundaries_md = '''# BOUNDARIES.md

## Default boundaries for first pilot
- Drafts only
- Reminders only
- Summaries only
- No autonomous external sending

## Needs confirmation from client
- off-limits contacts/topics
- escalation rules
- any extra-cautious message types
'''

samples_md = f'''# SAMPLES.md

## Captured from intake
### Problem statement
{problem}

### Desired 14-day win
{win}

## Still needed
- 3 examples of important messages
- 3 examples of low-priority/noisy messages
- 2–3 example replies in the client's tone
- 1 thread that went stale and should not have
'''

faq_md = '''# FAQ.md

## Internal notes
Use this file for client-specific FAQs, objections, and recurring clarifications during the pilot.
'''

log_md = f'''# LOG.md

## Pilot launched
- Hosted lead id: {lead_id}
- Name: {name}
- Business: {business}
- Email: {email}
- Website: {website or 'TBD'}
- Primary channel: {primary_channel}
- Contact preference: {contact_channel}
- Problem: {problem}
- Desired win: {win}
'''

kickoff_brief = f'''# Kickoff Brief — {client_display}

## Client snapshot
- Client / business: {business}
- Main contact: {name}
- Role: TBD
- Pilot dates: TBD
- Primary communication channel during pilot: {primary_channel}
- Preferred intake mode: forwarded lead emails or shared lead inbox

## Core problem
The client reported this core issue: {problem}

## Pilot scope
### Workflow in scope
- New inbound lead triage
- Stale follow-up reminders

### Channel in scope
- {primary_channel}

### Main job of the pilot
- surface important inbound
- draft replies
- flag stale follow-up
- create daily priorities

## Why this workflow was chosen first
- It directly addresses the stated pain
- It is narrow enough to prove value quickly
- It keeps the pilot inside a low-risk operator-assist scope

## Success definition
The pilot will be considered useful if it improves:
- response speed
- follow-up consistency
- daily clarity around what matters first
- client-specific win: {win}

## Priority rules
### High priority examples
- explicit buyer intent
- quote/proposal requests
- referrals

### Lower priority / ignore examples
- receipts
- newsletters
- automated notifications

## Tone guidance
- desired tone: warm, practical, concise
- phrases/style to emulate: TBD from real examples
- phrases/style to avoid: robotic or overhyped wording

## Follow-up logic
- stale threshold: TBD with client
- preferred follow-up style: gentle nudge by default
- any threads that should never be nudged: TBD

## Boundaries
- draft-only or broader: draft-only by default
- explicitly off-limits actions: autonomous external sending
- sensitive topics/accounts: TBD
- approval requirements: human review required

## Workflow constraints
- tools/systems already in use: TBD
- process limitations: TBD
- known friction points: follow-up inconsistency under load
- things already tried and failed: TBD

## Risks to watch
- too many false positives
- drafts miss tone
- scope broadens too quickly

## First implementation moves
1. gather message examples and tone samples
2. confirm stale threshold and escalation rules
3. run the workflow against the first narrow channel

## Check-in plan
- first review point: after initial examples are loaded
- second review point: end of first pilot week
- feedback owner: {name}
'''

intake_summary = f'''# Intake Snapshot — {client_display}

## From hosted lead capture
- Lead id: {lead_id}
- Name: {name}
- Business: {business}
- Email: {email}
- Website: {website or 'TBD'}
- Preferred contact channel: {contact_channel}
- Primary channel in scope: {primary_channel}

## Reported problem
{problem}

## Desired 14-day win
{win}

## Missing information to collect next
- role/title
- examples of important vs noisy messages
- tone examples
- stale threshold
- exclusions/boundaries
- check-in cadence
'''

write('README.md', readme)
write('CLIENT.md', client_md)
intake_mode_md = f'''# INTAKE-MODE.md

## Recommended mode
- Forwarded lead emails

## Why this is the default
- narrower scope than full inbox access
- easier trust story
- easier setup/offboarding
- enough visibility for triage + drafts + reminders

## Client-specific current channel
- {primary_channel}

## Other acceptable modes
- shared lead inbox
- CRM/form/webhook feed
- read-only inbox assist if truly needed

## Avoid by default
- full inbox access unless the workflow genuinely requires it
'''

write('CHANNELS.md', channels_md)
write('WORKFLOWS.md', workflows_md)
write('SUCCESS.md', success_md)
write('TONE.md', tone_md)
write('BOUNDARIES.md', boundaries_md)
write('SAMPLES.md', samples_md)
write('FAQ.md', faq_md)
write('LOG.md', log_md)
write('KICKOFF-BRIEF.md', kickoff_brief)
write('INTAKE-SNAPSHOT.md', intake_summary)
write('INTAKE-MODE.md', intake_mode_md)

print(client_dir)
print(client_display)
print(primary_channel)
print(problem)
print(win)
PY

CLIENT_DIR="$CLIENT_DIR"
if [[ ! -f "$STATUS_CSV" ]]; then
  echo 'client_slug,status,stage,primary_workflow,primary_channel,start_date,end_date,next_action,owner_notes' > "$STATUS_CSV"
fi

python3 - <<'PY' "$STATUS_CSV" "$SLUG"
import csv, sys, pathlib
path = pathlib.Path(sys.argv[1])
slug = sys.argv[2]
rows = []
if path.exists():
    with path.open() as f:
        reader = csv.DictReader(f)
        rows = list(reader)
fieldnames = ['client_slug','status','stage','primary_workflow','primary_channel','start_date','end_date','next_action','owner_notes']
filtered = [r for r in rows if r.get('client_slug') != slug]
filtered.append({
    'client_slug': slug,
    'status': 'qualified',
    'stage': 'kickoff-prep',
    'primary_workflow': 'inbound lead triage + stale follow-up',
    'primary_channel': 'email',
    'start_date': '',
    'end_date': '',
    'next_action': 'review kickoff brief and collect real message examples',
    'owner_notes': 'launched from hosted lead'
})
with path.open('w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(filtered)
PY

echo "Launched pilot workspace: $CLIENT_DIR"
echo "Kickoff brief: $CLIENT_DIR/KICKOFF-BRIEF.md"
echo "Intake snapshot: $CLIENT_DIR/INTAKE-SNAPSHOT.md"
echo "Next step: review the generated client files and collect real message examples."
