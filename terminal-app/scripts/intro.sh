#!/bin/bash

trap '' INT # ignore Ctrl+C while the script runs

echo "SIG_DISABLE_TERMINAL_INPUT"
clear
echo "SIG_AUGMENT_FONT_SIZE"
clear
echo "SIG_PLAY_INTRO_MUSIC"
clear

sleep 0.6

print_progress_bar() {
  local sleep_time="$1"
  for i in {0..100}; do
    filled=$(( i / 2 ))
    printf "\r%3d%% [%-50s]" "$i" "$(printf '%*s' "$filled" '' | tr ' ' '#')"
    sleep "$sleep_time"
  done
  printf "\n"
}

RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

declare -A ALERT_TXT=(
  [EN]="ALERT"
  [ES]="ALERTA"
)

echo -e "${YELLOW}${ALERT_TXT[$USER_LANG]}!!!${RESET}"
sleep 1
echo -e "${YELLOW}${ALERT_TXT[$USER_LANG]}!!!${RESET}"
sleep 1
echo -e "${YELLOW}${ALERT_TXT[$USER_LANG]}!!!${RESET}"

sleep 1.3

declare -A BEEN_HACKED_TXT=(
  [EN]="YOU'VE BEEN HACKED"
  [ES]="HAS SIDO HACKEADO"
)

end=$((SECONDS+4)) # run for num of seconds
while [ $SECONDS -lt $end ]; do
  echo -ne "${RED}----- ${BEEN_HACKED_TXT[$USER_LANG]} -----${RESET}\r"
  sleep 0.5
  echo -ne "                                                \r"
  sleep 0.5
done
echo -ne "${RED}----- ${BEEN_HACKED_TXT[$USER_LANG]} -----${RESET}\n"

declare -A EMPTYING_BANK_TXT=(
  [EN]="Emptying your bank account"
  [ES]="Vaciando tu cuenta bancaria"
)

echo -e "${YELLOW}${EMPTYING_BANK_TXT[$USER_LANG]}${RESET}"

print_progress_bar 0.05

declare -A TRANSFERING_MONEY_TXT=(
  [EN]="Transfering money to the Cayman Islands"
  [ES]="Transfiriendo los fondos a las Islas Caiman"
)

echo -e "${YELLOW}${TRANSFERING_MONEY_TXT[$USER_LANG]}${RESET}"

print_progress_bar 0.01

declare -A CONVERTING_USD_TXT=(
  [EN]="Converting u\$D to Bitcoin"
  [ES]="Convirtiendo los Dólares a Bitcoin"
)

echo -e "${YELLOW}${CONVERTING_USD_TXT[$USER_LANG]}${RESET}"

print_progress_bar 0.04

declare -A DELETING_HISTORY_TXT=(
  [EN]="Deleting transactions from Log History"
  [ES]="Borrando las transacciones del historial"
)

echo -e "${YELLOW}${DELETING_HISTORY_TXT[$USER_LANG]}${RESET}"

print_progress_bar 0.022

echo "SIG_REDUCE_FONT_SIZE"
clear

bash /app/scripts/putin-small.sh
sleep 1
clear
bash /app/scripts/kim-jong-un-small.sh
sleep 1
clear
bash /app/scripts/putin-big.sh
sleep 1
clear
bash /app/scripts/kim-jong-un-big.sh
sleep 1
clear

echo "SIG_RESTORE_FONT_SIZE"
clear

echo "SIG_STOP_INTRO_MUSIC"
clear

bash /app/scripts/rain.sh

clear
echo "SIG_PLAY_MORSE_SOUND"
clear

print_typing_effect() {
  text="$*"
  for ((i=0; i<${#text}; i++)); do
    printf "%s" "${text:$i:1}"
    sleep 0.05
  done
  echo
}

declare -A DONT_WORRY_TXT=(
  [EN]="Don't worry, I was just kidding."
  [ES]="No te preocupes, era una broma nada más."
)
print_typing_effect "${DONT_WORRY_TXT[$USER_LANG]}"

sleep 1

declare -A MONEY_SAFE_TXT=(
  [EN]="Your money is safe, nobody hacked into your bank accounts."
  [ES]="Tu plata está a salvo, nadie hackeó tus cuentas bancarias."
)
print_typing_effect "${MONEY_SAFE_TXT[$USER_LANG]}"
echo

sleep 1

declare -A TERMINAL_APPEAR_TXT_1=(
  [EN]="In a few seconds, a terminal will appear."
  [ES]="En unos segundos va a aparecer una terminal."
)
print_typing_effect "${TERMINAL_APPEAR_TXT_1[$USER_LANG]}"

sleep 1

declare -A DIFFERENT_TRADITIONAL_UI_TXT=(
  [EN]="This will be different from the traditional web page interface you are probably used to."
  [ES]="Esto va a ser distinto a la interfaz web tradicional a la que probablemente estás acostumbrado."
)
print_typing_effect "${DIFFERENT_TRADITIONAL_UI_TXT[$USER_LANG]}"

sleep 1

declare -A TERMINAL_COMUNICATE_PC_TXT_1=(
  [EN]="A terminal is basically another way to communicate with the PC."
  [ES]="Una terminal es básicamente otra forma de comunicarse con la PC."
)
print_typing_effect "${TERMINAL_COMUNICATE_PC_TXT_1[$USER_LANG]}"

sleep 1

declare -A INSTEAD_CLICKING_ICONS_TXT=(
  [EN]="Instead of clicking icons with your mouse, you type commands to interact and tell it what you want to do."
  [ES]="En vez de hacer click en íconos con el mouse, tenés que escribir comandos para interactuar y darle instrucciones de lo que querés hacer."
)
print_typing_effect "${INSTEAD_CLICKING_ICONS_TXT[$USER_LANG]}"

sleep 1

declare -A DETAILED_INSTRUCTIONS_TXT_1=(
  [EN]="I will leave you detailed instructions on how to use this terminal."
  [ES]="Te voy a dejar instrucciones detalladas sobre cómo usar esta terminal."
)
print_typing_effect "${DETAILED_INSTRUCTIONS_TXT_1[$USER_LANG]}"

sleep 1

declare -A READ_THEM_CAREFULLY_TXT=(
  [EN]="Read them carefully, they contain the different commands you can use."
  [ES]="Leelas con atención, ahí están los distintos comandos que podés usar."
)
print_typing_effect "${READ_THEM_CAREFULLY_TXT[$USER_LANG]}"

sleep 1

declare -A PRESS_ENTER_TXT=(
  [EN]="Press Enter when you are ready to continue."
  [ES]="Presioná Enter cuando estés listo para continuar."
)
print_typing_effect "${PRESS_ENTER_TXT[$USER_LANG]}"

sleep 0.01
echo "SIG_ENABLE_TERMINAL_INPUT"
sleep 0.01
echo "SIG_STOP_MORSE_SOUND"
sleep 0.01

read -r

bash /app/scripts/welcome-msg.sh
