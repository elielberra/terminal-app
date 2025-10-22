#!/bin/bash

echo "SIG_DISABLE_TOUCH"
clear
clear
echo "SIG_PAUSE_BACKGROUND_SOUND"
clear
echo "SIG_PLAY_GLADIATOR_MUSIC"
clear

YELLOW="\033[33m"
RESET="\033[0m"

sleep 2

declare -A DESERT_BATTLE_TXT=(
  [EN]="Among the deserts of the Middle East, the greatest battle took place."
  [ES]="Entre los desiertos de Medio Oriente, se libró una gran batalla."
)
echo "${DESERT_BATTLE_TXT[$LANG]}"

sleep 4

declare -A NATIONS_CLASH_TXT=(
  [EN]="Two nations clashed fiercely with one another in an epic combat."
  [ES]="Dos naciones se enfrentaron ferozmente en un épico combate."
)
echo "${NATIONS_CLASH_TXT[$LANG]}"

sleep 4

declare -A GROUP_23_TXT=(
  [EN]="A group of 11 men, led by their humble messiah, put an end to a 28-year curse."
  [ES]="Un grupo de 11 hombres, liderados por su humilde mesías, puso fin a una maldición de 28 años."
)
echo "${GROUP_23_TXT[$LANG]}"

sleep 4

declare -A HAPPINESS_STREETS_TXT=(
  [EN]="Happiness filled the country's streets."
  [ES]="La felicidad inundó las calles del país."
)
echo "${HAPPINESS_STREETS_TXT[$LANG]}"

sleep 4

declare -A GLORY_HISTORY_TXT=(
  [EN]="Glory was found, history was made."
  [ES]="Se alcanzó la gloria, se hizo historia."
)
echo "${GLORY_HISTORY_TXT[$LANG]}"

sleep 4

declare -A LUSAIL_TIME_TXT=(
  [EN]="Lusail Stadium — Saturday, December 18, 2022 — 18:00"
  [ES]="Estadio Lusail — Sábado 18 de diciembre de 2022 — 18:00 hs"
)
echo -e "\n\n${LUSAIL_TIME_TXT[$LANG]}\n\n"

sleep 8

echo -ne "${YELLOW}★${RESET}"
sleep 0.9
echo -ne "\r${YELLOW}★★${RESET}"
sleep 0.9
echo -e "\r${YELLOW}★★★${RESET}"
sleep 5

clear
echo "SIG_PLAY_ARG_FNC_MUSIC"
clear

mpv --vo=caca --no-audio --really-quiet /app/media/arg-fnc.mp4

clear
echo "SIG_STOP_ARG_FNC_MUSIC"
clear

clear
echo "SIG_STOP_GLADIATOR_MUSIC"
clear

bash /app/scripts/messi.sh
sleep 8

echo "SIG_PLAY_BACKGROUND_SOUND"
clear
echo "SIG_ENABLE_TOUCH"
clear
