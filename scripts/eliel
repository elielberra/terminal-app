#!/bin/bash

set -euo pipefail

print_help() {
  cat <<'EOF'
Usage:
  eliel hacker
  eliel world-champion
  eliel cv --language <esp|eng>
  eliel -h | --help

Commands:
  cv                Print the CV URL based on language.
  world-champion    Play a surprise video in ASCII Art style

Examples:
  eliel cv --language esp
EOF
}

cv_cmd() {
  local lang=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --language|--lang)
        [[ "${2:-}" != "" ]] || { echo "Error: missing value for $1" >&2; exit 2; }
        lang="$2"; shift 2
        ;;
      --language=*|--lang=*)
        lang="${1#*=}"; shift
        ;;
      -h|--help)
        print_help; exit 0
        ;;
      *)
        echo "Unknown option for 'cv': $1" >&2; exit 2
        ;;
    esac
  done

  case "${lang,,}" in
    esp|es|español|spanish)
      bash /app/scripts/download-cv.sh ESP
      ;;
    eng|en|english|ingles|inglés)
      bash /app/scripts/download-cv.sh ENG
      ;;
    "")
      bash /app/scripts/download-cv.sh ENG
      ;;
    *)
      echo "Error: unsupported language '$lang' (use esp|eng)" >&2; exit 2
      ;;
  esac
}

world_champion_cmd() {
  bash /app/scripts/arg-fnc-video.sh
}

hacker_cmd() {
  echo "01110000 01110101 01110100 01101111 00100000 01100101 01101100 "\
       "00100000 01110001 01110101 01100101 00100000 01101100 01100101 01100101"
}

main() {
  local cmd="${1:-}"
  [[ $# -gt 0 ]] && shift || true

  case "$cmd" in
    cv)              cv_cmd "$@" ;;
    world-champion)  world_champion_cmd ;;
    hacker)  hacker_cmd ;;
    -h|--help|help|"") print_help ;;
    *)
      echo "Unknown command: $cmd" >&2
      print_help
      exit 1
      ;;
  esac
}

main "$@"
