#!/bin/sh
tput setab 7; tput setaf 1;echo "5.1 Préconfig apt$(tput sgr 0)"
sudo debconf-set-selections /vagrant/preconfig.txt 2> /dev/null

tput setab 7; tput setaf 1;echo "5.2 Téléchargement des packages$(tput sgr 0)"
sudo apt-get update
sudo apt-get install -y --force-yes apache2 php5 php5-mysql mysql-server phpmyadmin libapache2-mod-wsgi libapache2-mod-php5 mysql-client php-pear curl php5-cli php5-dev php5-gd php5-curl php5-intl postfix mailutils git python-setuptools htop atop nethogs nmap multitail

tput setab 7; tput setaf 1;echo "5.3 Installation de Composer$(tput sgr 0)"
cd
curl -s https://getcomposer.org/installer | php
sudo ln -s /home/vagrant/composer.phar /usr/local/bin/composer

tput setab 7; tput setaf 1;echo "5.4 Installation de PHPUnit$(tput sgr 0)"
cd
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
sudo mv phpunit.phar /usr/bin/phpunit

tput setab 7; tput setaf 1;echo "5.5 Installation de ZeroMQ$(tput sgr 0)"
cd /vagrant/cortext-manager/src/Cortext/mcp
./install_zmq.sh

tput setab 7; tput setaf 1;echo "5.6 Installation de Supervisor$(tput sgr 0)"
cd
sudo easy_install supervisor

tput setab 7; tput setaf 1;echo "5.7 Installation de Meteor$(tput sgr 0)"
cd
curl https://install.meteor.com/ | sh

mkdir ~/.meteor_cortext_projects_local
ln -s ~/.meteor_cortext_projects_local/ /vagrant/cortext-projects/.meteor/local

cd /vagrant/cortext-projects
meteor > /dev/null &
sleep 5

tput setab 7; tput setaf 1;echo "5.8 Installation de Node$(tput sgr 0)"
while [ ! -f /home/vagrant/.meteor/packages/meteor-tool/1.1.10/mt-os.linux.x86_64/dev_bundle/bin/node ]
do
  sleep 1
done
sudo ln -s /home/vagrant/.meteor/packages/meteor-tool/1.1.10/mt-os.linux.x86_64/dev_bundle/bin/node /usr/local/bin/node
sudo ln -s /home/vagrant/.meteor/packages/meteor-tool/1.1.10/mt-os.linux.x86_64/dev_bundle/bin/npm /usr/local/bin/npm

tput setab 7; tput setaf 1;echo "6. Installation des BDD$(tput sgr 0)"
mysql -u root < /vagrant/scripts_sql/bdd_cortext.sql
mysql -u root ct_manager< /vagrant/cortext-manager/data/table-script-datas.sql

tput setab 7; tput setaf 1;echo "7.1 Fichiers de configuration de PHP$(tput sgr 0)"
cd /vagrant/config_files/
sudo cp etc/php5/cli/php.ini /etc/php5/cli/php.ini
sudo cp etc/php5/apache2/php.ini /etc/php5/apache2/php.ini

#Pour travailler en local, afin de permettre de recevoir des mails locaux, postfix est configuré pour recevoir les mails à destination de cortext.dev. Ce réglage ne doit donc pas être reproduit en production. Adapter le chemin pour être à la racine des fichiers de config.
tput setab 7; tput setaf 1;echo "7.2 Fichiers de configuration de PostFix$(tput sgr 0)"
cd /vagrant/config_files/
sudo cp etc/postfix/main.cf /etc/postfix/main.cf

tput setab 7; tput setaf 1;echo "7.3 Fichiers de configuration de PHPMyAdmin$(tput sgr 0)"
cd /vagrant/config_files/
sudo cp etc/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-enabled/phpmyadmin.conf

#Modification pour activer la coloration syntaxique, les alias, et le prompt. A ne pas reproduire en production !!
tput setab 7; tput setaf 1;echo "7.4 Fichiers de configuration du shell$(tput sgr 0)"
cd /vagrant/config_files/
cp home/vagrant/.bashrc /home/vagrant/.bashrc
cp home/vagrant/.bash_aliases /home/vagrant/.bash_aliases
chmod 644 /home/vagrant/.bash_aliases
sudo cp root/.bashrc /root/.bashrc
cd /home/vagrant
./.bashrc

tput setab 7; tput setaf 1;echo "7.5 Configuration Apache$(tput sgr 0)"
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

tput setab 7; tput setaf 1;echo "7.6 Fichiers de configuration des modules Cortext$(tput sgr 0)"

#Les fichiers de config sont présents dans le répertoire config_files/vagrant/. Ils sont configurés pour l'installation sur machine virtuelle avec des noms de domaines locaux. Pour une installation en production, les chemins et URL sont à adapter.

cd /vagrant
cp config_files/vagrant/cortext-auth/server/data/parameters.json cortext-auth/server/data/parameters.json
cp config_files/vagrant/cortext-manager/data/parameters.json cortext-manager/data/parameters.json
cp config_files/vagrant/cortext-manager/src/Cortext/mcp/config/config.php cortext-manager/src/Cortext/mcp/config/
cp config_files/vagrant/cortext-projects/env/parameters.js cortext-projects/env/parameters.js
sudo cp config_files/etc/supervisord.conf /etc/
cp config_files/vagrant/cortext-assets/server/app/config.php cortext-assets/server/app/config.php
chmod 664 cortext-assets/server/app/config.php

tput setab 7; tput setaf 1;echo "7.7 Fichier /etc/hosts$(tput sgr 0)"
echo "127.0.0.1 auth.cortext.dev assets.cortext.dev cortext.dev www.cortext.dev documents.cortext.dev" | sudo tee --append /etc/hosts > /dev/null

tput setab 7; tput setaf 1;echo "7.8 Locales$(tput sgr 0)"
echo "Europe/Paris" | sudo tee /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata
echo 'LANG="fr_FR.UTF-8"' | sudo tee /etc/default/locale
echo 'LANGUAGE="fr_FR:fr"' | sudo tee --append /etc/default/locale
sudo dpkg-reconfigure --frontend=noninteractive locales
sudo update-locale LANG=fr_FR.UTF-8

tput setab 7; tput setaf 1;echo "8. Téléchargement des dépendances PHP$(tput sgr 0)"

#Les modules Cortext se basent sur des modules PHP qu'il faut récupérer de manière automatique grâce à Composer. Chemin à adapter en fonction de l'emplacement des modules Cortext. Cette étape peut être un peu longue.

cd /vagrant/cortext-auth/server
COMPOSER_PROCESS_TIMEOUT=4000 composer update --prefer-dist

cd /vagrant/cortext-assets/server
composer update

cd /vagrant/cortext-manager
composer update

tput setab 7; tput setaf 1;echo "9. Reconstruction des BDD$(tput sgr 0)"
cd /vagrant/cortext-auth/server/data
php rebuild_db.php

tput setab 7; tput setaf 1;echo "10 Initialisation des fichiers log$(tput sgr 0)"
cd /vagrant
mkdir -p cortext-auth/server/log
touch cortext-auth/server/log/ctauth.log
mkdir -p cortext-assets/server/log
touch cortext-assets/server/log/assets.log
mkdir -p cortext-manager/log

tput setab 7; tput setaf 1;echo "11 Initialisation de l'arborescence$(tput sgr 0)"
cd /vagrant
mkdir -p cortext-assets/server/documents

tput setab 7; tput setaf 1;echo "12 Dummy Data$(tput sgr 0)"
mysql ct_auth -u root < /vagrant/scripts_sql/dummy_data.sql

tput setab 7; tput setaf 1;echo "13 Fin$(tput sgr 0)"
sudo service apache2 restart
supervisord -u vagrant -q /vagrant/log/supervisor
#echo Rebooter la machine virtuelle via les commandes suivantes:
#echo exit
#echo vagrant reload
