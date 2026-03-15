#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <client-slug> <display-name>"
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SLUG="$1"
NAME="$2"
STATUS_CSV="$SCRIPT_DIR/pilot-status.csv"
CLIENT_DIR="$SCRIPT_DIR/clients/$SLUG"

"$SCRIPT_DIR/new-client.sh" "$SLUG"

if [[ ! -f "$STATUS_CSV" ]]; then
  echo 'client_slug,status,stage,primary_workflow,primary_channel,start_date,end_date,next_action,owner_notes' > "$STATUS_CSV"
fi

printf '%s,%s,%s,%s,%s,%s,%s,%s,%s\n' \
  "$SLUG" \
  "qualified" \
  "kickoff-prep" \
  "inbound lead triage" \
  "email" \
  "" \
  "" \
  "fill intake and kickoff brief" \
  "$NAME" >> "$STATUS_CSV"

echo "Promoted lead to client workspace: $CLIENT_DIR"
echo "Added status row for: $SLUG"
