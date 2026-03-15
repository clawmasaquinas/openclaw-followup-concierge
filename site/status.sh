#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PID_FILE="../logs/site.pid"
if [[ -f "$PID_FILE" ]]; then
  PID="$(cat "$PID_FILE")"
  if kill -0 "$PID" 2>/dev/null; then
    echo "OpenClaw live-business site appears to be running on 127.0.0.1:8080 (PID $PID)"
    exit 0
  fi
fi
if fuser 8080/tcp >/dev/null 2>&1; then
  echo "OpenClaw live-business site appears to be running on 127.0.0.1:8080 (PID unknown)"
else
  echo "OpenClaw live-business site is not running"
fi
