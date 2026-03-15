#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
./stop-bg.sh || true
sleep 1
./start-bg.sh
