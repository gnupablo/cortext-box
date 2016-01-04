#!/bin/sh

#Il faut augmenter les capacités d'upload de fichier, et assurer la compatibilité en autorisant les Short Open Tag. Adapter le chemin pour être à la racine des fichiers de config.
echo "8.1 Fichiers de configuration de PHP"
cd /vagrant/config_files/
sudo cp etc/php5/cli/php.ini /etc/php5/cli/php.ini
sudo cp etc/php5/apache2/php.ini /etc/php5/apache2/php.ini

#Pour travailler en local, afin de permettre de recevoir des mails locaux, postfix est configuré pour recevoir les mails à destination de cortext.dev. Ce réglage ne doit donc pas être reproduit en production. Adapter le chemin pour être à la racine des fichiers de config.
echo "8.2 Fichiers de configuration de PostFix"
cd /vagrant/config_files/
sudo cp etc/postfix/main.cf /etc/postfix/main.cf

#Cette modification permet d'autoriser la connexion sans mot de passe, car le compte root n'a pas de mot de passe pour l'environnement de dev. A ne pas reproduire en production !!
echo "8.3 Fichiers de configuration de PHPMyAdmin"
cd /vagrant/config_files/
sudo cp etc/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-enabled/phpmyadmin.conf

#Modification pour activer la coloration syntaxique, les alias, et le prompt. A ne pas reproduire en production !!
echo "8.4 Fichiers de configuration du shell"
cd /vagrant/config_files/
cp home/vagrant/.bashrc /home/vagrant/.bashrc
cp home/vagrant/.bash_aliases /home/vagrant/.bash_aliases
chmod 644 /home/vagrant/.bash_aliases
sudo cp root/.bashrc /root/.bashrc
source /home/vagrant/.bashrc

#Activation des modules apache
echo "8.5 Fichiers de configuration de Apache 2.4"
sudo a2enmod rewrite headers 
sudo a2dismod -f autoindex status access_compat

#Copie des fichiers de configuration Apache. Adapter éventuellement les fichiers en fonction de l'emplacement des fichiers sources et des fichiers de logs. Les fichiers sont prévus pour une installation en machine virtuelle dans le répertoire /vagrant sur des noms de domaines locaux. Les noms de domaines sont également à adapter.

cd /vagrant/config_files/
sudo cp etc/apache2/envvars /etc/apache2/envvars
sudo cp etc/apache2/sites-available/*.conf /etc/apache2/sites-available/
sudo chmod 644 /etc/apache2/sites-available/*.conf

#Activation des nouveaux sites installés et désactivation du site par défaut

sudo a2dissite 000-default
sudo a2ensite assets manager documents auth

echo "8.6 Fichiers de configuration des modules Cortext"

#Les fichiers de config sont présents dans le répertoire config_files/vagrant/. Ils sont configurés pour l'installation sur machine virtuelle avec des noms de domaines locaux. Pour une installation en production, les chemins et URL sont à adapter.

cd /vagrant
cp config_files/vagrant/cortext-auth/server/data/parameters.json cortext-auth/server/data/parameters.json

cp config_files/vagrant/cortext-manager/data/parameters.json cortext-manager/data/parameters.json

cp config_files/vagrant/cortext-projects/env/parameters.js cortext-projects/env/parameters.js
cp config_files/vagrant/cortext-projects/private/api/config.json cortext-projects/private/api/config.json

sudo cp config_files/etc/supervisord.conf /etc/


cp config_files/vagrant/cortext-assets/server/app/config.php cortext-assets/server/app/config.php
chmod 664 cortext-assets/server/app/config.php

echo "Ajouter maintenant sur la machine hôte les redirections nécessaires dans /etc/hosts. Une fois dans la machine virtuelle, et une fois sur la machine physique dans un autre terminal donc, et si ce n'est pas déjà fait. Voir 8.7 de la procédure."
echo "Une fois cela fait, passer à vagrant-config-cortext-2.sh"
