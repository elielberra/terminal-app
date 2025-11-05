#!/bin/bash

ESP="ESP"
ENG="ENG"

cv_lang="$1"
if [[ "$cv_lang" != "$ESP" && "$cv_lang" != "$ENG" ]]; then
  echo "Error: argument must be ESP or ENG"
  exit 1
fi

sleep 0.001
echo "SIG_OPEN_CV_${cv_lang}"
sleep 0.001

declare -A INTERESTS_TXT=(
  [EN]="Professionally, I’m interested in projects where I can combine my Software Development, Cloud Infrastructure, Cybersecurity and AI Engineering skills."
  [ES]="Profesionalmente, me interesan los proyectos donde pueda combinar mis habilidades en Desarrollo de Software, Infraestructura en la Nube, Ciberseguridad e Ingeniería de IA."
)

echo -e "\n${INTERESTS_TXT[$USER_LANG]}\n" | fmt -w $(tput cols)
