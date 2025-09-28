#!/bin/bash

trap '' INT    # ignore Ctrl+C while the script runs

clear

print_progress_bar() {
  local sleep_time="$1"
  for i in {0..100}; do
    filled=$(( i / 2 ))  # bar width = 50
    printf "\r%3d%% [%-50s]" "$i" "$(printf '%*s' "$filled" '' | tr ' ' '#')"
    sleep "$sleep_time"
  done
  printf "\n"
}

# Define colors
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

sleep 0.6 
echo -e "${YELLOW}ALERT!!${RESET}"
sleep 1
echo -e "${YELLOW}ALERT!!${RESET}"
sleep 1
echo -e "${YELLOW}ALERT!!${RESET}"

end=$((SECONDS+5))   # run for 5 seconds

while [ $SECONDS -lt $end ]; do
  # Print in red and overwrite the same line
  echo -ne "${RED}----- YOU'VE BEEN HACKED -----${RESET}\r"
  sleep 0.5
  # Clear the line
  echo -ne "                                                \r"
  sleep 0.5
done
echo -ne "${RED}----- YOU'VE BEEN HACKED -----${RESET}\n"

echo -e "${YELLOW}Emptying your bank account${RESET}"

print_progress_bar 0.05

echo -e "${YELLOW}Transfering money to the Caiman Islands${RESET}"

print_progress_bar 0.01

echo -e "${YELLOW}Converting u\$D to Bitcoin${RESET}"

print_progress_bar 0.03

echo -e "${YELLOW}Deleting transactions from Log History${RESET}"

print_progress_bar 0.005

bash ./scripts/rain2.sh