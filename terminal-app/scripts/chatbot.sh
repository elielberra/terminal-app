#!/bin/bash

YELLOW="\033[0;33m"
BLUE="\033[1;34m"
RESET="\033[0m"

echo -e "${BLUE}Chatbot started. Type 'exit' to quit.${RESET}"

while true; do
  echo -ne "${YELLOW}You:${RESET} "
  read user_input
  if [[ "$user_input" == "exit" ]]; then
    echo -e "${BLUE}Chatbot:${RESET} Goodbye!"
    break
  fi
   payload=$(jq -nc --arg q "$user_input" '{question:$q}')

  response=$(curl -sS --unix-socket /sockets/rag.sock \
    -X POST http://localhost/ask \
    -H "Content-Type: application/json" \
    -d "$payload")
  answer=$(echo "$response" | jq -r '.answer')
  echo -e "${BLUE}Chatbot:${RESET} $answer"
done
