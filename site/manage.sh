#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
cmd="${1:-}"
case "$cmd" in
  start) exec ./run.sh ;;
  start-bg) exec ./start-bg.sh ;;
  stop) exec ./stop.sh ;;
  stop-bg) exec ./stop-bg.sh ;;
  restart) exec ./restart.sh ;;
  status) exec ./status.sh ;;
  logs) exec ./logs.sh ;;
  *)
    echo "Usage: $0 {start|start-bg|stop|stop-bg|restart|status|logs}"
    exit 1
    ;;
esac
