#!/bin/bash

clear
echo "SIG_PLAY_BACKGROUND_SOUND"
clear

declare -A GRAPHICS_WARNING_TXT=(
  [EN]="First, let me warn you that a video in super ultra HD is going to be displayed. You will need a powerful NVIDIA GPU to render this graphics. Second... France."
  [ES]="Primero, dejame advertirte que se va a mostrar un video en súper ultra HD. Necesitarás una GPU NVIDIA potente para renderizar estos gráficos. Segundo... Francia."
)

echo -e "${YELLOW}${GRAPHICS_WARNING_TXT[$LANG]}!!!${RESET}"


echo "Welcome to my webpage"
