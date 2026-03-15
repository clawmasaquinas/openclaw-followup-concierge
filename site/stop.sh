#!/usr/bin/env bash
set -euo pipefail
fuser -k 8080/tcp || true
