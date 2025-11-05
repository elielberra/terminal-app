#!/bin/bash

  clear
sleep 0.001
echo "SIG_DISABLE_TERMINAL_INPUT"
sleep 0.001
echo "SIG_AUGMENT_FONT_SIZE"
sleep 0.001
echo "SIG_PLAY_INTRO_MUSIC"
sleep 0.6

print_progress_bar() {
  local sleep_time="$1"
  for i in {0..100}; do
    filled=$(( i / 4 ))
    printf "\r%3d%% [%-25s]" "$i" "$(printf '%*s' "$filled" '' | tr ' ' '#')"
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

clear
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

end=$((SECONDS+4))
while [ $SECONDS -lt $end ]; do
  echo -ne "${RED}----- ${BEEN_HACKED_TXT[$USER_LANG]} -----${RESET}\r"
  sleep 0.5
  echo -ne "                                                \r"
  sleep 0.5
done
echo -ne "${RED}----- ${BEEN_HACKED_TXT[$USER_LANG]} -----${RESET}\n"

declare -A BRUTE_FORCING_TXT=(
  [EN]="Brute forcing access to your banking system"
  [ES]="Forzando el acceso a tu sistema bancario"
)
echo -e "${YELLOW}${BRUTE_FORCING_TXT[$USER_LANG]}${RESET}"
print_progress_bar 0.025

declare -A EMPTYING_BANK_TXT=(
  [EN]="Emptying your bank account"
  [ES]="Vaciando tu cuenta bancaria"
)
echo -e "${YELLOW}${EMPTYING_BANK_TXT[$USER_LANG]}${RESET}"
print_progress_bar 0.025

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
print_progress_bar 0.015

declare -A SENDING_BTC_TXT=(
  [EN]="Sending Bitcoin to a crypto wallet in Pyongyang"
  [ES]="Enviando Bitcoin a una billetera cripto en Pyongyang"
)
echo -e "${YELLOW}${SENDING_BTC_TXT[$USER_LANG]}${RESET}"
print_progress_bar 0.02

declare -A DELETING_HISTORY_TXT=(
  [EN]="Deleting transactions from Log History"
  [ES]="Borrando las transacciones del historial"
)
echo -e "${YELLOW}${DELETING_HISTORY_TXT[$USER_LANG]}${RESET}"
print_progress_bar 0.033

sleep 0.001
echo "SIG_REDUCE_FONT_SIZE"
sleep 0.001
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

echo "SIG_AUGMENT_FONT_SIZE"
sleep 0.001
echo "SIG_STOP_INTRO_MUSIC"
sleep 0.001

bash /app/scripts/rain.sh

sleep 0.001
echo "SIG_PLAY_MORSE_SOUND"
sleep 0.001

print_typing_effect() {
  local text="$*"
  local cols
  cols=$(tput cols 2>/dev/null || echo 80)
  local wrapped
  wrapped=$(printf "%s" "$text" | fold -s -w "$cols")
  local i
  for (( i=0; i<${#wrapped}; i++ )); do
    printf "%s" "${wrapped:i:1}"
    sleep 0.03
  done
  printf "\n"
}

declare -A JUST_KDDING_TXT=(
  [EN]="I was just kidding, your money is safe."
  [ES]="Era una broma nada más, tu plata está a salvo."
)
print_typing_effect "${JUST_KDDING_TXT[$USER_LANG]}"
echo
sleep 1

declare -A TERMINAL_APPEAR_TXT_1=(
  [EN]="In a few seconds, a terminal will appear."
  [ES]="En unos segundos va a aparecer una terminal."
)
print_typing_effect "${TERMINAL_APPEAR_TXT_1[$USER_LANG]}"
echo
sleep 1

declare -A DIFFERENT_TRADITIONAL_UI_TXT=(
  [EN]="This will be different from the traditional web page interface you are probably used to."
  [ES]="Esto va a ser distinto a la interfaz web tradicional a la que probablemente estás acostumbrado."
)
print_typing_effect "${DIFFERENT_TRADITIONAL_UI_TXT[$USER_LANG]}"
echo
sleep 1

declare -A WONT_BE_CLICKING_TXT=(
  [EN]="You won’t be clicking icons with your mouse like you usually do on websites."
  [ES]="No vas a estar haciendo click en íconos con el mouse como hacés siempre en las páginas web."
)
print_typing_effect "${WONT_BE_CLICKING_TXT[$USER_LANG]}"
echo
sleep 1

declare -A TERMINAL_COMUNICATE_PC_TXT_1=(
  [EN]="A terminal is basically another way to communicate with the PC."
  [ES]="Una terminal es básicamente otra forma de comunicarse con la PC."
)
print_typing_effect "${TERMINAL_COMUNICATE_PC_TXT_1[$USER_LANG]}"
echo
sleep 1

declare -A TYPE_COMMANDS_TXT=(
  [EN]="You’ll type commands to interact with the app and tell it what you want to do."
  [ES]="Vas a escribir comandos para interactuar con la app y decirle qué querés hacer."
)
print_typing_effect "${TYPE_COMMANDS_TXT[$USER_LANG]}"
echo
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

clear
sleep 0.001
echo "SIG_DEFAULT_FONT_SIZE"
sleep 0.5
bash /app/scripts/welcome-msg.sh
