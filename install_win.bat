@echo off
echo.
echo ######## 3. Recuperation des sources depuis GitHub ########

echo ######## 3.1 Cortext-auth ########
git clone --recursive git@github.com:cortext/cortext-auth.git

echo.
echo ######## 3.2 Silex-simpleuser ########
cd cortext-auth/server/vendor/cortext/silex-simpleuser
git checkout master
cd ../../../../..

echo.
echo ######## 3.3 Cortext-assets ########
git clone --recursive git@github.com:cortext/cortext-assets.git

echo.
echo ######## 3.4 Cortext-manager ########
git clone --recursive git@github.com:cortext/cortext-manager.git

echo.
echo ######## 3.5 Cortext-projects ########
git clone --recursive git@github.com:cortext/cortext-projects.git

echo.
echo ######## 3.6 Cortext-methods ########
git clone --recursive git@github.com:cortext/cortext-methods.git

echo.
echo ######## 3.7 Identification de l'installation en environnement Windows ########
echo. > win_install.flag

echo.
echo ######## 4. Telechargement de la machine virtuelle ########
echo Une fois la machine virtuelle demarree, lancer la suite de l'execution par la commande suivante:
echo install_inside.sh
vagrant up
vagrant ssh
