#/bin/sh

echo -e "\e[1;32m=== Script d'initialisation de la machine virtuelle\e[0m"

# Se placer dans un répertoire de travail qui accueillera la machine virtuelle
echo -n -e "\n\e[1;31mCortext va etre installe dans le repertoire courant [O/n] ? \e[0m"
read res

# Cas par défaut
if [ -z $res ]
then
   res=o
fi

if [ "$res" != "O" ] && [ "$res" != "o" ]
then
   echo -e "\n\e[1;32m=== Placez vous dans le répertoire d'installation, au besoin crééz-le avec \e[1;31mmkdir <nom du répertoire>\e[0m\n"
   exit 1
fi

echo -e "\n\e[1;32m=== Vérification des pré-requis logiciel\e[0m"
dpkg-query -s git 2>/dev/null | grep -i "Status: install" >/dev/null
if [ "$?" != "0" ]
then
   echo -e "\e[1;31m=== Git est un pré-requis à l'installation, merci de l'installer :\nsudo apt-get install git\e[0m"
   exit 1
fi

dpkg -s linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') 2>/dev/null | grep -i "Status: install" >/dev/null
if [ "$?" != "0" ]
then
   echo -e "\e[1;31m=== Linux headers est un pré-requis à l'installation, merci de l'installer :\nsudo apt-get install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,')\e[0m"
   exit 1
fi

dpkg-query -s vagrant 2>/dev/null | grep -i "Status: install" >/dev/null
if [ "$?" != "0" ]
then
   echo -e "\e[1;31m=== Vagrant est un pré-requis à l'installation, merci de le telecharger depuis :\nhttps://www.vagrantup.com/downloads.html\npuis installer le package avec la commande\nsudodpkg -i nomdupackage\e[0m"
   exit 1
fi

echo -e "\e[1;32m=== Démarrage de la machine virtuelle, avec téléchargement de l'image lors du premier chargement\e[0m"
vagrant up

echo -e "\e[1;32m=== Clonage des modules Cortext\e[0m"
. 1b_clonage_Cortext.sh

echo -e "\e[1;32m=== Poursuivre l'installation dans le répertoire /vagrant pour executer le script suivant :
\e[1;31m=== cd /vagrant
=== sudo su
=== ./2_install_MV.sh\e[1;32m

=== Connexion par ssh à la machine virtuelle\e[0m"
vagrant ssh
