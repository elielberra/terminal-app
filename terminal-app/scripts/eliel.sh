#!/bin/bash

set -euo pipefail

print_help() {
  bash /app/scripts/instructions.sh
  cat <<'EOF'
Usage:
  eliel champion
  eliel cv --language <esp|eng>
  eliel hacker
  eliel -h | --help

Commands:
  champion          Play a surprise video
  cv                Download a CV in PDF format
  hacker            Get hints for a scavenger hunt
  docs              Open repository documentation
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

champion_cmd() {
  bash /app/scripts/arg-fnc-video.sh
}

hacker_cmd() {
  sleep 0.001
  echo "SIG_COPY_BINARY_CLIPBOARD"
  sleep 0.5
  binaryHint="01100011 01100001 01110100 00100000 00101111 01101000 01101111 01101101 01100101 00101111 01110111 01100101 \
01100010 00101101 01110101 01110011 01100101 01110010 00101111 01101000 01101001 01101110 01110100 00101101 00110001"
  echo "${binaryHint}" | fmt -w $(tput cols)
}

docs_cmd() {
  sleep 0.001
  echo "SIG_OPEN_CYBERSECURITY_DOCS"
  sleep 0.001
}

main() {
  local cmd="${1:-}"
  [[ $# -gt 0 ]] && shift || true

  case "$cmd" in
    cv)        cv_cmd "$@" ;;
    champion)  champion_cmd ;;
    hacker)    hacker_cmd ;;
    docs)      docs_cmd ;;
    -h|--help|help|"") print_help ;;
    *)
      echo "Unknown command: $cmd" >&2
      print_help
      exit 1
      ;;
  esac
}

main "$@"
