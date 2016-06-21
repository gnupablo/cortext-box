#!/bin/sh

tput setab 7; tput setaf 1;echo "3. Récupération des sources depuis GitHub$(tput sgr 0)"

tput setab 7; tput setaf 1;echo "3.1 Cortext-auth$(tput sgr 0)"
git clone -b risis --recursive git@github.com:cortext/cortext-auth.git

tput setab 7; tput setaf 1;echo "3.2 Silex-simpleuser$(tput sgr 0)"
cd cortext-auth/server/vendor/cortext/silex-simpleuser
git checkout master
cd ../../../../..

tput setab 7; tput setaf 1;echo "3.3 Cortext-assets$(tput sgr 0)"
git clone -b risis --recursive git@github.com:cortext/cortext-assets.git

tput setab 7; tput setaf 1;echo "3.4 Cortext-manager$(tput sgr 0)"
git clone -b risis_v1 --recursive git@github.com:cortext/cortext-manager.git

tput setab 7; tput setaf 1;echo "3.5 Cortext-projects$(tput sgr 0)"
git clone -b risis_v2 --recursive git@github.com:cortext/cortext-projects.git

tput setab 7; tput setaf 1;echo "3.6 Cortext-methods$(tput sgr 0)"
git clone -b risis --recursive git@github.com:cortext/cortext-methods.git

tput setab 7; tput setaf 1;echo "4. Téléchargement de la machine virtuelle$(tput sgr 0)"
echo "Une fois la machine virtuelle démarrée, lancer la suite de l'exécution par la commande suivante:"
echo "install_inside.sh"
vagrant up && vagrant ssh
