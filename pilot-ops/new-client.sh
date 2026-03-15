#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <client-slug>"
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
TEMPLATE_DIR="$WORKSPACE_ROOT/pilot-template"
CLIENTS_DIR="$SCRIPT_DIR/clients"
SLUG="$1"
TARGET_DIR="$CLIENTS_DIR/$SLUG"

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  echo "Pilot template not found: $TEMPLATE_DIR"
  exit 1
fi

if [[ -e "$TARGET_DIR" ]]; then
  echo "Client workspace already exists: $TARGET_DIR"
  exit 1
fi

mkdir -p "$CLIENTS_DIR"
cp -R "$TEMPLATE_DIR" "$TARGET_DIR"

cat > "$TARGET_DIR/README.md" <<EOF
# $SLUG

Client pilot workspace created from the shared pilot template.

## Next steps
1. Fill in CLIENT.md
2. Fill in CHANNELS.md
3. Fill in WORKFLOWS.md
4. Fill in TONE.md
5. Fill in BOUNDARIES.md
6. Fill in SUCCESS.md
7. Add real examples to SAMPLES.md
8. Use LOG.md as the running pilot log
EOF

echo "Created client workspace: $TARGET_DIR"
