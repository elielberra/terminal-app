#!/bin/bash

clear
sleep 0.001
echo "SIG_DISABLE_TERMINAL_INPUT"
sleep 0.001
echo "SIG_AUGMENT_FONT_SIZE"
sleep 0.001
echo "SIG_HIDE_THEME_VOL_BTNS"
sleep 0.001
echo "SIG_SHOW_CLOSE_VIDEO_BTN"
sleep 0.001
echo "SIG_PAUSE_BACKGROUND_SOUND"
sleep 0.001
echo "SIG_PLAY_GLADIATOR_MUSIC"
sleep 0.001

YELLOW="\033[33m"
RESET="\033[0m"
ITALIC="\e[3m"
RESET_ITALIC="\e[0m"

sleep 2

declare -A DESERT_BATTLE_TXT=(
  [EN]="Among the deserts of the Middle East, the greatest battle of history took place."
  [ES]="En los desiertos de Medio Oriente, se libró la batalla más importante de la historia."
)
clear
echo -e "${DESERT_BATTLE_TXT[$USER_LANG]}\n" | fmt -w $(tput cols)

sleep 5

declare -A NATIONS_CLASH_TXT=(
  [EN]="Two nations clashed fiercely with one another in an epic combat."
  [ES]="Dos naciones se enfrentaron ferozmente en un épico combate."
)
echo -e "${NATIONS_CLASH_TXT[$USER_LANG]}\n" | fmt -w $(tput cols)

sleep 5

declare -A GROUP_23_TXT=(
  [EN]="A group of 11 men, led by their humble messiah, put an end to a 28-year curse."
  [ES]="Un grupo de 11 hombres, liderados por su humilde mesías, puso fin a una maldición de 28 años."
)
echo -e "${GROUP_23_TXT[$USER_LANG]}\n" | fmt -w $(tput cols)

sleep 5

declare -A HAPPINESS_STREETS_TXT=(
  [EN]="Happiness filled the country's streets."
  [ES]="La felicidad inundó las calles del país."
)
echo -e "${HAPPINESS_STREETS_TXT[$USER_LANG]}\n" | fmt -w $(tput cols)

sleep 4

declare -A GLORY_HISTORY_TXT=(
  [EN]="Glory was found, a new legend was written..."
  [ES]="Se alcanzó la gloria, se escribió una nueva leyenda..."
)
echo -e "${GLORY_HISTORY_TXT[$USER_LANG]}\n" | fmt -w $(tput cols)

sleep 4

declare -A LUSAIL_TIME_TXT=(
  [EN]="Lusail, Qatar — Saturday, December 18th, 2022 — 18:00 hs"
  [ES]="Lusail, Qatar — Sábado 18 de diciembre de 2022 — 18:00 hs"
)
echo -e "${ITALIC}${LUSAIL_TIME_TXT[$USER_LANG]}${RESET_ITALIC}\n" | fmt -w $(tput cols)

sleep 5

echo -ne "${YELLOW}★${RESET}"
sleep 0.9
echo -ne "\r${YELLOW}★★${RESET}"
sleep 0.9
end=$((SECONDS+5))
while [ $SECONDS -lt $end ]; do
  echo -ne "\r${YELLOW}★★★${RESET}\r"
  sleep 0.45
  echo -ne "   \r"
  sleep 0.45  
done

clear -x
sleep 0.001
echo "SIG_REDUCE_FONT_SIZE"
sleep 1
echo "SIG_PLAY_ARG_FNC_MUSIC"
sleep 0.001

mpv --vo=caca --no-audio --really-quiet /app/media/arg-fnc.mp4
exit_code=$?
if [ $exit_code -eq 4 ]; then
  exit
fi

sleep 0.001
echo "SIG_STOP_GLADIATOR_MUSIC_FADE_OUT"
sleep 0.001
clear -x
bash /app/scripts/messi.sh
sleep 8

echo "SIG_DEFAULT_FONT_SIZE"
sleep 0.001
echo "SIG_PLAY_BACKGROUND_SOUND"
sleep 0.001
echo "SIG_ENABLE_TERMINAL_INPUT"
sleep 0.001
echo "SIG_DISPLAY_THEME_VOL_BTNS"
sleep 0.001
echo "SIG_HIDE_CLOSE_VIDEO_BTN"
sleep 0.001
clear -x
bash /app/scripts/instructions.sh
