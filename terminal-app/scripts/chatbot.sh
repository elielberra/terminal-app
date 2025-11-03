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

EXAMPLE_QUESTIONS_EN="
- What is your favourite movie, TV series, music, book, or ice cream?
- What are your hobbies?
- Have you ever worked with Python? What about other programming languages?
- What are your cloud engineering and infrastructure skills?
- What is your professional experience with Artificial Intelligence?
- If you had to defect from North Korea, which escape route would you use?
- Which football club are you a fan of? Who is your favourite football player?
- Give me a summary of your academic background.
- Can you speak English?
- How can I try to contact you?
"
EXAMPLE_QUESTIONS_ES="
- ¿Cuál es tu película, serie, música, libro o helado favorito?
- ¿Cuáles son tus hobbies?
- ¿Alguna vez trabajaste con Python? ¿Y con otros lenguajes de programación?
- ¿Cuáles son tus habilidades trabajando con la nube y con infraestructura?
- ¿Cuál es tu experiencia profesional con Inteligencia Artificial?
- Si tuvieras que escapar de Corea del Norte, ¿qué ruta usarías?
- ¿De qué club de fútbol sos hincha? ¿Quién es tu jugador favorito?
- Dame un resumen de tu formación académica.
- ¿Sabés hablar inglés?
- ¿Cómo te puedo contactar?
"

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
