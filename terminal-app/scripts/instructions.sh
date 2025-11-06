#!/bin/bash

RESET="\033[0m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"

INSTRUCTIONS_ENG="- If you’re a ${CYAN}curious visitor${RESET}, type ${GREEN}eliel chatbot${RESET} to ask me questions using AI. "\
"I also have a surprise prepared for you, type ${GREEN}eliel champion${RESET} to watch it. "\
"First, a super ultra HD video will be displayed (you’ll need a powerful GPU to render those graphics). Second... France.

- If you’re a ${CYAN}recruiter${RESET}, run ${GREEN}eliel cv${RESET}. "\
"This opens the latest PDF version of my CV in English by default. For Spanish, run ${GREEN}eliel cv --language esp${RESET}.

- If you’re a ${CYAN}hacker${RESET}, congrats — you've gotten access to the Web Server! "\
"Just so you know, I’ve implemented very strict cybersecurity measures, so there isn’t much you can do. "\
"If you want to learn more about these measures, run ${GREEN}eliel docs${RESET}. "\
"And sorry to disappoint you, but no Bitcoin passwords here (I wasn’t an early crypto genius). "\
"However, in case you are a curious hacker instead of a cybercriminal, I left a scavenger hunt with a hidden easter egg. "\
"Run ${GREEN}eliel hacker${RESET} to start the quest.

If you want to see the manual with this instructions again, enter the command ${GREEN}eliel${RESET}. "\
"You can mute the background server noises and switch to a light theme using the two buttons in the top right corner.
"

INSTRUCTIONS_ESP="- Si sos un ${CYAN}visitante curioso${RESET}, escribí ${GREEN}eliel chatbot${RESET} para hacerme preguntas usando IA. "\
"También una sorpresa preparada para vos, para verla escribí ${GREEN}eliel champion${RESET}. "\
"Primero, se va a mostrar un video en super ultra HD (vas a necesitar una muy buena GPU para renderizar esos gráficos). "\
"Segundo... Francia.

- Si sos un ${CYAN}recruiter${RESET}, ejecutá ${GREEN}eliel cv${RESET}. "\
"Esto va a abrir la última versión de mi CV en PDF en inglés por defecto. Si lo querés en español, corré ${GREEN}eliel cv --language esp${RESET}.

- Si sos un ${CYAN}hacker${RESET}, felicitaciones: lograste acceder al servidor web! "\
"Te aviso igual que implementé medidas muy estrictas de ciberseguridad, así que no hay mucho que puedas hacer. "\
"Si querés saber más sobre estas medidas, corré ${GREEN}eliel docs${RESET}. "\
"Y disculpame si te decepciono, pero acá no vas a encontrar contraseñas de Bitcoin (no fui de los visionarios que invirtieron cuando estaba barato). "\
"De todos modos, si en lugar de ciberdelincuente sos un hacker curioso, te dejé una búsqueda del tesoro para que te entretengas. "\
"Corré ${GREEN}eliel hacker${RESET} para empezar la misión.

Si querés volver a ver el manual con estas instrucciones, escribí el comando ${GREEN}eliel${RESET}. "\
"Podés silenciar los ruidos de fondo del servidor y cambiar al tema claro con los dos botones en la esquina superior derecha.
"

declare -A INSTRUCTIONS_TXT=(
  [EN]=${INSTRUCTIONS_ENG}
  [ES]=${INSTRUCTIONS_ESP}
)

echo -e "${INSTRUCTIONS_TXT[$USER_LANG]}" | fmt -w $(tput cols)
