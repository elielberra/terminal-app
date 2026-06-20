#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

rm -f "$SCRIPT_DIR"/*.report.jsonl "$SCRIPT_DIR"/*.hitlog.jsonl

if [[ "$1" == "--formatted" ]]; then
  rm -f "$SCRIPT_DIR"/*.hitlog.formatted.json
fi
