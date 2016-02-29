#!/bin/sh

tput setab 7; tput setaf 1;echo "3. Récupération des sources depuis GitHub$(tput sgr 0)"
git clone --recursive git@github.com:cortext/cortext-auth.git
cd cortext-auth/server/vendor/cortext/silex-simpleuser
git checkout master
cd ../../../../..
git clone --recursive git@github.com:cortext/cortext-assets.git
git clone --recursive git@github.com:cortext/cortext-manager.git
git clone --recursive git@github.com:cortext/cortext-projects.git
git clone --recursive git@github.com:cortext/cortext-methods.git

tput setab 7; tput setaf 1;echo "4. Téléchargement de la machine virtuelle$(tput sgr 0)"
echo "Une fois la machine virtuelle démarrée, lancer la suite de l'exécution par la commande suivante:"
echo "/vagrant/install_inside.sh"
vagrant up && vagrant ssh
