#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT/site"
./manage.sh start-bg
sleep 1
cd "$ROOT"
./status.sh
