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
  response=$(curl -s -X POST http://rag-chain:5000/ask \
    -H "Content-Type: application/json" \
    -d "{\"question\": \"${user_input}\"}")    
  answer=$(echo "$response" | jq -r '.answer')
  echo -e "${BLUE}Chatbot:${RESET} $answer"
done
