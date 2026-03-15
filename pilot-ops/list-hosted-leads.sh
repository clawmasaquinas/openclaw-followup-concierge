#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
TOKEN_FILE="$ROOT/.local-secrets/admin-token.txt"

if [[ ! -f "$TOKEN_FILE" ]]; then
  echo "Admin token file missing: $TOKEN_FILE"
  exit 1
fi

TOKEN="$(cat "$TOKEN_FILE")"
TMP_JSON="$(mktemp)"
trap 'rm -f "$TMP_JSON"' EXIT
curl -fsS -H "x-admin-token: $TOKEN" https://live-business.vercel.app/api/leads > "$TMP_JSON"
python3 - <<'PY' "$TMP_JSON"
import sys, json, pathlib
payload = json.loads(pathlib.Path(sys.argv[1]).read_text())
leads = payload.get('leads', [])
if not leads:
    print('No hosted leads found.')
    raise SystemExit(0)
for lead in leads:
    print(f"#{lead.get('id')} | {lead.get('name')} | {lead.get('business') or '—'} | {lead.get('email')} | {lead.get('primary_channel') or '—'} | {lead.get('created_at')}")
    print(f"  problem: {lead.get('problem')}")
    print(f"  win: {lead.get('win') or '—'}")
    print()
PY
