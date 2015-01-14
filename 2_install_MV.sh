#/bin/sh

# Apres la creation de la machine virtuelle, ce script realise l'installation et 
# la configuration du systeme pour que les differents modules cortext puissent
# s'executer, puis realise l'installation de ces modules


# Verification que l'execution se fait bien en etant root et pas depuis un sudo

if [ `id -u -n` != "root" ]
then
   echo -e "\e[1;31mVous devez être root pour executer cette application\e[0m"
   exit
elif [ "$EUID" != 0 ]
then
   echo "Bien essayé le sudo, mais on a dit root, donc su ou sudo su d'abord."
   exit
fi

echo -e "\e[1;32m=== Script d'installation de la machine virtuelle\e[0m"


# Mise a jour du systeme

echo -e "\e[1;32m=== Mise à jour de la machine virtuelle\e[0m"
apt-get update
apt-get -y --force-yes upgrade


# Chargement de la liste des packages a installer et de leurs parametres

debconf-set-selections /vagrant/preconfig.txt


# Declenchement de l'installation des packages

echo -e "\e[1;32m=== Installation des packages nécessaires à Cortext\e[0m"
apt-get install -y --force-yes apache2 php5 php5-mysql mysql-server phpmyadmin libapache2-mod-wsgi libapache2-mod-php5 mysql-client php-pear curl php5-cli php5-dev php5-gd php5-curl php5-intl git postfix mailutils


# Configuration du serveur Web Apache

echo -e "\e[1;32m=== Activation des modules apache\e[0m"
a2enmod rewrite headers

echo -e "\e[1;32m=== Modification du groupe d'exécution apache\e[0m"
sed -i 's/export APACHE_RUN_GROUP=www-data/export APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars

echo -e "\e[1;32m=== On permet un mot de passe vide pour la BDD\e[0m"
sed -i "s/\/\/ \$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE/\$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE/" /etc/phpmyadmin/config.inc.php

echo -e "\e[1;32m=== Ajout du virtual hosts Phpmyadmin\e[0m"
ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf.d/phpmyadmin.conf

echo -e "\e[1;32m=== Modification du umask Apache\e[0m"
echo umask 0002 >> /etc/apache2/envvars

echo -e "\e[1;32m=== Augmentation de la taille maximal d'upload\e[0m"
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 200M/g' /etc/php5/apache2/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 200M/g' /etc/php5/cli/php.ini

echo -e "\e[1;32m=== Redémarrage d'Apache pour prendre en compte la nouvelle config\e[0m"
service apache2 restart


# Configuration du serveur mail Postfix pour qu'il traite les mails locaux

echo -e "\e[1;32m=== Configuration de postfix\e[0m"
sed -i 's/debian-7.7.0-amd64/cortext.dev/' /etc/postfix/main.cf
sed -i 's/inet_interfaces = all/inet_interfaces = loopback-only/' /etc/postfix/main.cf
echo "default_transport = error
relay_transport = error" >> /etc/postfix/main.cf
service postfix restart


# Installation de Composer necessaire pour les installations des modules

echo -e "\e[1;32m=== Téléchargement de Composer\e[0m"
cd /home/vagrant
curl -s https://getcomposer.org/installer | php

echo -e "\e[1;32m=== Création d'un lien vers Composer\e[0m"
ln -s /home/vagrant/composer.phar /usr/local/bin/composer


# Creation du script bash_aliases pour disposer immediatemment des alias

echo -e "\e[1;32m=== Création des alias\e[0m"
echo "export LS_OPTIONS='--color=auto'" >> /home/vagrant/.bash_aliases
echo "eval \"`dircolors`\"" >> /home/vagrant/.bash_aliases
echo "alias ls='ls \$LS_OPTIONS'" >> /home/vagrant/.bash_aliases
echo "alias ll='ls \$LS_OPTIONS -lrth'" >> /home/vagrant/.bash_aliases
echo "alias la='ls \$LS_OPTIONS -lA'" >> /home/vagrant/.bash_aliases
echo "alias l='ls \$LS_OPTIONS -l'" >> /home/vagrant/.bash_aliases
 
echo "export LS_OPTIONS='--color=auto'" >> /root/.bashrc
echo "eval \"`dircolors`\"" >> /root/.bashrc
echo "alias ls='ls $LS_OPTIONS'" >> /root/.bashrc
echo "alias ll='ls $LS_OPTIONS -lrth'" >> /root/.bashrc
echo "alias la='ls $LS_OPTIONS -lA'" >> /root/.bashrc
echo "alias l='ls $LS_OPTIONS -l'" >> /root/.bashrc

. /home/vagrant/.bash_aliases


# Installation de phpunit

echo -e "\e[1;32m=== Téléchargement de PHPUnit\e[0m"
wget https://phar.phpunit.de/phpunit.phar

echo -e "\e[1;32m=== Attribution des droits d'éxecution\e[0m"
chmod +x phpunit.phar

echo -e "\e[1;32m=== Installation de PHPUnit\e[0m"
mv phpunit.phar /usr/bin/phpunit


# Lancement de l'installation des modules Cortext

echo -e "\e[1;32m=== Appels des scripts d'installation des modules Cortext\e[0m"
cd /vagrant
. 3_install_Auth.sh
. 4_install_Assets.sh
. 5_install_Manager.sh
. add_etc_hosts.sh


# Fin de l'installation, suggestion de l'etape suivante

echo -e "\e[1;32m=== Fin, vous pouvez maintenant ajouter des données de test avec la commande suivante:\e[0m"
echo -e "\e[1;31m./6_dummy_data.sh\e[0m"
