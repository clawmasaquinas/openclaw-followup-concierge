#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PID_FILE="../logs/site.pid"
if [[ -f "$PID_FILE" ]]; then
  PID="$(cat "$PID_FILE")"
  kill "$PID" 2>/dev/null || true
  sleep 1
  rm -f "$PID_FILE"
  echo "Stopped background process $PID"
else
  echo "No PID file found; falling back to port-based stop"
fi
./stop.sh
