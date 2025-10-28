#!/bin/bash

sleep 0.001
echo "SIG_DISPLAY_THEME_VOL_BTNS"
sleep 0.001
echo "SIG_PLAY_BACKGROUND_SOUND"
sleep 0.001

WELCOME_MSG_ENG="Hello and welcome to my webpage!

If you’re wondering why you’re seeing a terminal instead of a UI, it’s because I’m not great at designing things "\
"and I think this is an interesting way for people to get to know who I am. "\
"The commands you can use to interact with this webpage are listed below and highlighted in green. "\
"Type them exactly as shown and press Enter to execute them:
"

WELCOME_MSG_ESP="¡Hola y bienvenid@ a mi página web!

Si te estás preguntando por qué ves una terminal en lugar de una interfaz, es porque no soy muy bueno diseñando cosas. "\
"y me parece una forma alternativa interesante para que la gente me conozca un poco más. "\
"Los comandos que podés usar están detallados acá abajo y coloreados en verde. "\
"Escribilos exactamente como están y presioná Enter para ejecutarlos:
"

declare -A WELCOME_MSG_TXT=(
  [EN]=${WELCOME_MSG_ENG}
  [ES]=${WELCOME_MSG_ESP}
)

sleep 0.5
clear -x
echo -e "${WELCOME_MSG_TXT[$USER_LANG]}" | fmt -w $(tput cols)
bash /app/scripts/instructions.sh
