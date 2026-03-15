#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p ../logs
if [[ -f ../logs/site.pid ]] && kill -0 "$(cat ../logs/site.pid)" 2>/dev/null; then
  echo "Background site already running with PID $(cat ../logs/site.pid)"
  exit 0
fi
nohup ./run.sh >> ../logs/site.log 2>&1 &
echo $! > ../logs/site.pid
echo "Started background site process with PID $(cat ../logs/site.pid)"
