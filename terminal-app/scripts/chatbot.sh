#!/bin/bash

YELLOW="\033[1;38;5;136m"
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RESET="\033[0m"

INTERACTIVE_CHATBOT_ENG="This is an interactive chatbot powered by AI. "\
"You can ask me questions about myself and I will try to answer them. "\
"If you can't think of anything to ask, simply type ${GREEN}questions${RESET} and a list of examples will appear. "\
"Type ${GREEN}exit${RESET} to quit."

INTERACTIVE_CHATBOT_ESP="Este es un chatbot interactivo con inteligencia artificial. "\
"Podés hacerme preguntas sobre mí y voy a tratar de responderlas. "\
"Si no se te ocurre qué preguntar, escribí ${GREEN}preguntas${RESET} y va a aparecer una lista con ejemplos. "\
"Escribí ${GREEN}salir${RESET} para cerrar el chatbot."

declare -A INTERACTIVE_CHATBOT_TXT=(
  [EN]=${INTERACTIVE_CHATBOT_ENG}
  [ES]=${INTERACTIVE_CHATBOT_ESP}
)

EXAMPLE_QUESTIONS_EN="- Where are you from?\n- What technologies do you use?\n- What projects have you built?\n- What is your experience with Python?\n- Can you describe your background?"
EXAMPLE_QUESTIONS_ES="- ¿De dónde sos?\n- ¿Qué tecnologías usás?\n- ¿Qué proyectos creaste?\n- ¿Cuál es tu experiencia con Python?\n- ¿Podés contarme tu trayectoria?"

declare -A EXAMPLE_QUESTIONS_TXT=(
  [EN]=${EXAMPLE_QUESTIONS_EN}
  [ES]=${EXAMPLE_QUESTIONS_ES}
)

YOU_EN="You"
YOU_ES="Vos"

declare -A YOU_TXT=(
  [EN]=${YOU_EN}
  [ES]=${YOU_ES}
)

GOODBYE_EN="Goodbye!"
GOODBYE_ES="¡Chau!"

declare -A GOODBYE_TXT=(
  [EN]=${GOODBYE_EN}
  [ES]=${GOODBYE_ES}
)

clear -x
echo -e "${INTERACTIVE_CHATBOT_TXT[$USER_LANG]}" | fmt -w $(tput cols)

while true; do
  echo -ne "${YELLOW}${YOU_TXT[$USER_LANG]}:${RESET} "
  read user_input
  if [[ "${user_input,,}" == "exit" || "${user_input,,}" == "salir" ]]; then
    echo -e "${BLUE}Eliel:${RESET} ${GOODBYE_TXT[$USER_LANG]}"
    break
  elif [[ "${user_input,,}" == "questions" || "${user_input,,}" == "preguntas" ]]; then
    echo -e "${EXAMPLE_QUESTIONS_TXT[$USER_LANG]}" | fmt -w "$(tput cols)"
    continue
  fi
  payload=$(jq -nc --arg q "$user_input" '{question:$q}')
  response=$(curl -sS --unix-socket /sockets/rag.sock \
    -X POST http://localhost/ask \
    -H "Content-Type: application/json" \
    -d "$payload")
  answer=$(echo "$response" | jq -r '.answer')
  echo -e "${BLUE}Eliel:${RESET} $answer" | fmt -w "$(tput cols)"
done
