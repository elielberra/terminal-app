#!/bin/bash

ESP="ESP"
ENG="ENG"

cv_lang="$1"
if [[ "$cv_lang" != "$ESP" && "$cv_lang" != "$ENG" ]]; then
  echo "Error: argument must be ESP or ENG"
  exit 1
fi

sleep 0.001
echo "SIG_DOWNLOAD_CV_${cv_lang}"
sleep 0.001

declare -A DRIVE_FOLDER_TXT=(
  [EN]="In case the file was not downloaded automatically, here is the link to the Google Drive folder:"
  [ES]="En caso de que el archivo no se haya descargado automáticamente, este es el enlace a la carpeta de Google Drive:"
)

echo "${DRIVE_FOLDER_TXT[$USER_LANG]}"
DRIVE_LINK="https://drive.google.com/drive/folders/1S1ePqptM1x7wHTav5CvHAuMEvdvmoear?usp=sharing"
echo -e "\n\n${DRIVE_LINK}\n\n"

declare -A INTERESTS_TXT=(
  [EN]="Professionally, I’m interested in projects where I can combine my Software Development, Cloud Infrastructure, Cybersecurity and AI Engineering skills.

If you’d like to get to know me on a more personal level, here’s a list of some of my favorite things:
- Book: Edge of Eternity by Ken Follett
- Movie: The Big Short
- TV Series: The Office
- Album: Yo-Yo Ma Plays Ennio Morricone
- Football team: Bianchi’s Boca Juniors from 2003
- Football player: Ronaldinho (after Messi, of course)
- Ice cream flavor: Dulce de leche with chocolate flakes
- Escape route from North Korea: Cross the frozen Tumen River into China during winter. From there, travel north through underground networks. Cross the Gobi Desert and seek political asylum in Mongolia.
- Countries I’ve never been to but would like to visit: Ecuador, Norway, Bhutan, Botswana, Australia
"
  [ES]="Profesionalmente, me interesan los proyectos donde pueda combinar mis habilidades en Desarrollo de Software, Infraestructura en la Nube, Ciberseguridad e Ingeniería de IA.

Si querés conocerme un poco más a nivel personal, acá hay una lista de algunas de mis cosas favoritas:
- Libro: El Umbral de la Eternidad de Ken Follett  
- Película: La Gran Apuesta
- Serie: The Office  
- Álbum: Yo-Yo Ma con Ennio Morricone  
- Equipo de fútbol: El Boca de Bianchi del 2000  
- Jugador de fútbol: Ronaldinho (después de Messi, obviamente)  
- Helado: Dulce de leche granizado
- Ruta de escape de Corea del Norte: Cruzar el río Tumen congelado hacia China durante el invierno. Desde ahí, viajar hacia el norte a través de redes clandestinas. Cruzar el desierto del Gobi y pedir asilo político en Mongolia
- Países a los que nunca fui pero me gustaría visitar: Ecuador, Noruega, Bhutan, Botsuana, Australia
"
)

echo "${INTERESTS_TXT[$USER_LANG]}"
