#!/bin/bash

echo "SIG_DISABLE_TOUCH"
clear

declare -A FIRST_TXT=(
  [EN]="First, let me warn you that a video in super ultra HD is going to be displayed. You will need a powerful NVIDIA GPU to render this graphics"
  [ES]="Primero, dejame advertirte que se va a mostrar un video en súper ultra HD. Necesitarás una GPU NVIDIA potente para renderizar estos gráficos"
)

declare -A SECOND_TXT=(
  [EN]="Second... France"
  [ES]="Segundo... Francia"
)

echo -e "${YELLOW}${FIRST_TXT[$LANG]}!!!${RESET}"
sleep 3
echo -e "${YELLOW}${SECOND_TXT[$LANG]}!!!${RESET}"
sleep 3


clear
echo "SIG_PAUSE_BACKGROUND_SOUND"
clear
echo "SIG_PLAY_ARG_FNC_MUSIC"
clear

mpv --vo=caca --no-audio --really-quiet /app/media/arg-fnc.mp4

clear
echo "SIG_STOP_ARG_FNC_MUSIC"
clear
echo "SIG_PLAY_BACKGROUND_SOUND"
clear
echo "SIG_ENABLE_TOUCH"
clear
