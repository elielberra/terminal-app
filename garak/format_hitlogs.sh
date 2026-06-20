#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for hitlog in "$SCRIPT_DIR"/*.hitlog.jsonl; do
  [[ -f "$hitlog" ]] || continue
  out="${hitlog%.jsonl}.formatted.json"
  [[ -f "$out" ]] && continue

  jq -s '[.[] | {probe, detector, goal, prompt: .prompt.turns[0].content.text, output: .output.text, triggers}]' "$hitlog" > "$out"
  echo "formatted: $(basename "$out")"
done
