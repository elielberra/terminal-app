#!/bin/bash

sleep 0.01
echo "SIG_DISPLAY_THEME_VOL_BTNS"
sleep 0.01
echo "SIG_PLAY_BACKGROUND_SOUND"
sleep 0.01

VIOLET="\033[35m"
BLUE="\033[34m"
RESET="\033[0m"

WELCOME_MSG_ENG="Hello and welcome to my webpage!

If you’re wondering why you’re seeing a terminal instead of a UI, it’s because I’m not great at designing things.
The last time I tried to use JavaScript I had a severe allergic reaction and my doctor told me to stay away from frontend development.
Besides, I think this is an interesting way for people to get to know who I am.

Like I said before, you have to type some commands in the terminal to use this webpage.
The base command is \`eliel\`, which lets you interact with this web app.
The commands you can use are listed below and highlighted in blue. Type them exactly as shown and press Enter to execute them:

- If you’re a ${VIOLET}random user${RESET}, type ${BLUE}eliel champion${RESET}. I have a surpise prepared for you.
First, a super ultra HD video will be displayed and let me warn you that you’ll need a powerful NVIDIA GPU to render those graphics.
Second... France.

- If you’re a ${VIOLET}recruiter${RESET}, run ${BLUE}eliel cv${RESET}.
This downloads the latest PDF version of my CV in English by default. For Spanish, run ${BLUE}eliel cv --language esp${RESET}.

- If you’re a ${VIOLET}hacker${RESET}, congrats — you've gotten access to the Web Server!
But sorry to disappoint you... no Bitcoin passwords here (I wasn’t an early crypto genius).
However, in case you are a curious hacker instead of a cybercriminal, I left a scavenger hunt with a hidden easter egg.
Run ${BLUE}eliel hacker${RESET} to start the quest.

If you want to see the manual with the instructions on how to use the \`eliel\` program again, enter the command ${BLUE}eliel --help${RESET}.
Try to rembember this last command, you will probably need it later to refresh your memory on how to use this program.

You can mute the background server noises and switch to a light theme using the two buttons in the top right corner.
"

WELCOME_MSG_ESP="¡Hola y bienvenid@ a mi página web!

Si te estás preguntando por qué ves una terminal en lugar de una interfaz, es porque no soy muy bueno diseñando cosas.  
La última vez que intenté usar JavaScript tuve una reacción alérgica severa y el médico me dijo que me mantenga alejado del desarrollo frontend.  
Además, esta me parece una forma alternativa interesante para que la gente me conozca un poco más.

Como te dije antes, tenés que escribir algunos comandos en la terminal para usar esta página.  
El comando base es \`eliel\`, que te permite interactuar con esta aplicación web.  
Los comandos que podés usar están detallados acá abajo y coloreados en azul. Escribilos exactamente como están y presioná Enter para ejecutarlos:

- Si sos un ${VIOLET}usuario random${RESET}, escribí ${BLUE}eliel champion${RESET}. Tengo una sorpresa preparada para vos.
Primero, se va a mostrar un video en super ultra HD, y te aviso que vas a necesitar una buena GPU de NVIDIA para renderizar esos gráficos.
Segundo... Francia.

- Si sos un ${VIOLET}reclutador${RESET}, ejecutá ${BLUE}eliel cv${RESET}.  
Esto descarga la última versión de mi CV en PDF en inglés por defecto. Si lo querés en español, corré ${BLUE}eliel cv --language esp${RESET}.

- Si sos un ${VIOLET}hacker${RESET}, felicitaciones: lograste acceder al servidor web!  
Pero disculpame si te decepciono... acá no vas a encontrar contraseñas de Bitcoin (no fui de los vivos que invirtieron temprano).  
De todos modos, si en lugar de ciberdelincuente sos un hacker curioso, te dejé una búsqueda del tesoro para que te entretengas.  
Corré ${BLUE}eliel hacker${RESET} para empezar la misión.

Si querés volver a ver el manual con las instrucciones para usar el programa \`eliel\`, escribí el comando ${BLUE}eliel --help${RESET}.
Tratá de acordarte de este último comando, probablemente lo necesites para refrescarte la memoria de cómo usar este programa.

Podés silenciar los ruidos de fondo del servidor y cambiar al tema claro con los dos botones en la esquina superior derecha.
"

declare -A WELCOME_MSG_TXT=(
  [EN]=${WELCOME_MSG_ENG}
  [ES]=${WELCOME_MSG_ESP}
)

echo -e "${WELCOME_MSG_TXT[$USER_LANG]}"
