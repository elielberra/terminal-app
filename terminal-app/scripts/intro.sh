#!/bin/bash

trap '' INT # ignore Ctrl+C while the script runs

echo "SIG_DISABLE_TOUCH"
clear
# echo "SIG_PLAY_INTRO_MUSIC"
# clear

# sleep 0.6

# print_progress_bar() {
#   local sleep_time="$1"
#   for i in {0..100}; do
#     filled=$(( i / 2 ))
#     printf "\r%3d%% [%-50s]" "$i" "$(printf '%*s' "$filled" '' | tr ' ' '#')"
#     sleep "$sleep_time"
#   done
#   printf "\n"
# }

# RED="\033[31m"
# YELLOW="\033[33m"
# RESET="\033[0m"

# declare -A ALERT_TXT=(
#   [EN]="ALERT"
#   [ES]="ALERTA"
# )

# echo -e "${YELLOW}${ALERT_TXT[$LANG]}!!!${RESET}"
# sleep 1
# echo -e "${YELLOW}${ALERT_TXT[$LANG]}!!!${RESET}"
# sleep 1
# echo -e "${YELLOW}${ALERT_TXT[$LANG]}!!!${RESET}"

# sleep 1.3

# declare -A BEEN_HACKED_TXT=(
#   [EN]="YOU'VE BEEN HACKED"
#   [ES]="HAS SIDO HACKEADO"
# )

# end=$((SECONDS+4)) # run for num of seconds
# while [ $SECONDS -lt $end ]; do
#   echo -ne "${RED}----- ${BEEN_HACKED_TXT[$LANG]} -----${RESET}\r"
#   sleep 0.5
#   echo -ne "                                                \r"
#   sleep 0.5
# done
# echo -ne "${RED}----- ${BEEN_HACKED_TXT[$LANG]} -----${RESET}\n"

# declare -A EMPTYING_BANK_TXT=(
#   [EN]="Emptying your bank account"
#   [ES]="Vaciando tu cuenta bancaria"
# )

# echo -e "${YELLOW}${EMPTYING_BANK_TXT[$LANG]}${RESET}"

# print_progress_bar 0.05

# declare -A TRANSFERING_MONEY_TXT=(
#   [EN]="Transfering money to the Cayman Islands"
#   [ES]="Transfiriendo los fondos a las Islas Caiman"
# )

# echo -e "${YELLOW}${TRANSFERING_MONEY_TXT[$LANG]}${RESET}"

# print_progress_bar 0.01

# declare -A CONVERTING_USD_TXT=(
#   [EN]="Converting u\$D to Bitcoin"
#   [ES]="Convirtiendo los Dólares a Bitcoin"
# )

# echo -e "${YELLOW}${CONVERTING_USD_TXT[$LANG]}${RESET}"

# print_progress_bar 0.03

# declare -A DELETING_HISTORY_TXT=(
#   [EN]="Deleting transactions from Log History"
#   [ES]="Borrando las transacciones del historial"
# )

# echo -e "${YELLOW}${DELETING_HISTORY_TXT[$LANG]}${RESET}"

# print_progress_bar 0.017

# bash /app/scripts/rain.sh

# echo "SIG_REDUCE_FONT_SIZE"
# clear

# bash /app/scripts/putin-small.sh
# sleep 1
# clear
# bash /app/scripts/kim-jong-un-small.sh
# sleep 1
# clear
# bash /app/scripts/putin-big.sh
# sleep 1
# clear
# bash /app/scripts/kim-jong-un-big.sh
# sleep 1
# clear

# echo "SIG_RESTORE_FONT_SIZE"
# clear

# echo "SIG_STOP_INTRO_MUSIC"
# clear

print_typing_effect() {
  text="$*"
  clear
  echo "SIG_PLAY_MORSE_SOUND"
  clear
  for ((i=0; i<${#text}; i++)); do
    printf "%s" "${text:$i:1}"
    sleep 0.05
  done
  clear
  echo "SIG_PAUSE_MORSE_SOUND"
  clear
  echo
}

print_typing_effect "Hello my friend"

bash /app/scripts/welcome-msg.sh
