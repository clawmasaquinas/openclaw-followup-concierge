#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SITE_DIR="$ROOT/site"
PILOT_DIR="$ROOT/pilot-ops"
DATA_DIR="$ROOT/data"

printf '== Live Business Status ==\n'
printf 'Root: %s\n\n' "$ROOT"

printf '[Site service]\n'
if [[ -x "$SITE_DIR/manage.sh" ]]; then
  (cd "$SITE_DIR" && ./manage.sh status)
else
  echo 'Site manage.sh not found'
fi

printf '\n[Lead data]\n'
if [[ -f "$DATA_DIR/leads.json" ]]; then
  python3 - <<PY
import json
from pathlib import Path
p = Path(r'''$DATA_DIR/leads.json''')
try:
    leads = json.loads(p.read_text())
    print(f'Captured leads: {len(leads)}')
except Exception as e:
    print(f'Could not parse leads.json: {e}')
PY
else
  echo 'No leads.json yet'
fi

printf '\n[Pilot ops]\n'
if [[ -f "$PILOT_DIR/pilot-status.csv" ]]; then
  echo 'Recent pilot-status rows:'
  tail -n 5 "$PILOT_DIR/pilot-status.csv"
else
  echo 'No pilot-status.csv found'
fi
