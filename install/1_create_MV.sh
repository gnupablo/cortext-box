#/bin/sh

echo -e "\e[1;32m=== Script d'initialisation de la machine virtuelle\e[0m"

# Se placer dans un répertoire de travail qui accueillera la machine virtuelle

echo -e "\e[1;32m=== Initialisation de la config Vagrant\e[0m"
vagrant init dhoppe/debian-7.7.0-amd64-nocm

echo -e "\e[1;32m=== Modification de la config pour pouvoir accéder à la machine en http via le port 8080\e[0m"
sed -i 's/\# config.vm.network \"forwarded_port\", guest: 80, host: 8080/config.vm.network \"forwarded_port\", guest: 80, host: 8080/' Vagrantfile

echo -e "\e[1;32m=== Désactivation de la mise à jour automatique de la box, pour éviter une attente de timeout quand on travaille en déconnecté\e[0m"
sed -i 's/\# config.vm.box_check_update = false/config.vm.box_check_update = false/' Vagrantfile

echo -e "\e[1;32m=== Changement des droits par défaut du montage /vagrant\e[0m"
sed -i 's/\# config.vm.synced_folder "..\/data", "\/vagrant_data"/config.vm.synced_folder ".", "\/vagrant", :extra => "dmode=777,fmode=666"/' Vagrantfile

echo -e "\e[1;32m=== Démarrage de la machine virtuelle, avec téléchargement de l'image lors du premier chargement\e[0m"
vagrant up

echo -e "\e[1;32m=== Clonage des modules Cortext\e[0m"
. 1b_clonage_Cortext.sh

echo -e "\e[1;32m=== Modification du fichier /etc/hosts de la machine physique\e[0m"
for i in `echo auth.cortext.dev assets.cortext.dev cortext.dev www.cortext.dev`
do
   grep -E -sq "127\.0\.0\.1.*$i" /etc/hosts && host=1 || host=0
   if [ host -eq 0 ]; then echo "127.0.0.1      $i" >> /etc/hosts; fi
done

echo -e "\e[1;32m=== Pour poursuivre l'installation, aller dans le répertoire /vagrant pour executer le script suivant avec les commandes suivantes :
\e[1;31m=== cd /vagrant
=== ./2_install_MV.sh\e[1;32m

=== Connexion par ssh à la machine virtuelle\e[0m"
vagrant ssh
