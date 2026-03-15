#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
LOG_FILE="../logs/site.log"
if [[ -f "$LOG_FILE" ]]; then
  tail -n 50 "$LOG_FILE"
else
  echo "No log file yet: $LOG_FILE"
fi
