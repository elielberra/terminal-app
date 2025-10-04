#!/bin/bash

lang="$1"
ESP="ESP"
ENG="ENG"
if [[ "$lang" != "$ESP" && "$lang" != "$ENG" ]]; then
  echo "Error: argument must be ESP or ENG"
  exit 1
fi

clear
echo "SIG_DOWNLOAD_CV_${lang}"
clear

echo -e "In case the file is not automatically downloaded here is the link:\n\nhttps://drive.google.com/drive/folders/1S1ePqptM1x7wHTav5CvHAuMEvdvmoear?usp=sharing\n\n"

# Interests Software Development, Cloud Infrastructure and Gen AI
echo
echo
# Favourites, The big short, ken follet fall of giants, yoyo ma ennio, the office, korea to mongolia, boca de bianchi del 2000, ronaldiño (messi es muy obvio), dulce de leche granizado
