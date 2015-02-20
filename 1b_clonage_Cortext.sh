#/bin/sh

echo -e "\e[1;32m=== Script de clone des différents modules de la plateforme cortext\e[0m"
#clear
echo
option=-1

# Boucle
while [ $option -ne 0 ] && [ $option -ne 9 ]
do
# Affichage du menu
echo 1 - Cortext Auth
echo 2 - Cortext Assets
echo 3 - Cortext Manager
echo 4 - Cortext Projects
echo 5 - Cortext Methods
echo
echo 9 - Tous et quitter
echo
echo 0 - Quitter
echo
printf "Choix (défaut 9) ? "
read option

# Gestion du choix par défaut
if [ -z $option ]
then
   option=9
fi

if [ $option -eq 1 ] || [ $option -eq 9 ]
then 
   echo -e "\n\e[1;32m=== Clonage de Cortext Auth depuis Github\e[0m"
   git clone --recursive git@github.com:cortext/cortext-auth.git
   # Ajout d'un checkout au niveau du submodule sinon les modifs ne pourront pas être poussées
   cd cortext-auth/server/vendor/cortext/silex-simpleuser
   git checkout master
   cd ../../../../..
fi

if [ $option -eq 2 ] || [ $option -eq 9 ]
then
   echo -e "\n\e[1;32m=== Clonage de Cortext Assets depuis Github\e[0m"
   git clone --recursive git@github.com:cortext/cortext-assets.git
fi

if [ $option -eq 3 ] || [ $option -eq 9 ]
then
   echo -e "\n\e[1;32m=== Clonage de Cortext Manager depuis Github\e[0m"
   git clone --recursive git@github.com:cortext/cortext-manager.git
fi

if [ $option -eq 4 ] || [ $option -eq 9 ]
then
   echo -e "\n\e[1;32m=== Clonage de Cortext Projects depuis Github\e[0m"
   git clone --recursive git@github.com:cortext/cortext-projects.git
fi

if [ $option -eq 5 ] || [ $option -eq 9 ]
then
   echo -e "\n\e[1;32m=== Clonage de Cortext Methods depuis Github\e[0m"
   git clone --recursive git@github.com:cortext/cortext-methods.git
fi

done
echo -e "\e[1;32m=== Fin du clonage\e[0m"
