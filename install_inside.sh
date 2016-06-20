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
echo "" | ./install_zmq.sh --force-yes


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
while [ ! -f /home/vagrant/.meteor/packages/meteor-tool/*/mt-os.linux.x86_64/dev_bundle/bin/node ]
do
  sleep 1
done
for i in `find /home/vagrant/.meteor/packages/meteor-tool/*/mt-os.linux.x86_64/dev_bundle/bin/ -name node`
do
  node=$i
done
for j in `find /home/vagrant/.meteor/packages/meteor-tool/*/mt-os.linux.x86_64/dev_bundle/bin/ -name npm`
do
  npm=$j
done
sudo ln -s $node /usr/local/bin/node
sudo ln -s $npm /usr/local/bin/npm


tput setab 7; tput setaf 1;echo "6. Installation des BDD$(tput sgr 0)"
tput setab 7; tput setaf 1;echo "6.1 Creation des tables$(tput sgr 0)"
mysql -u root < /vagrant/scripts_sql/bdd_cortext.sql

tput setab 7; tput setaf 1;echo "6.2 Insertion de la table des scripts$(tput sgr 0)"
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
sh /home/vagrant/.bashrc


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
cp config_files/vagrant/cortext-auth/server/views/cgu.twig cortext-auth/server/views/cgu.twig
cp config_files/vagrant/cortext-auth/server/views/conditions.twig cortext-auth/server/views/conditions.twig
cp config_files/vagrant/cortext-auth/server/views/mentions.twig cortext-auth/server/views/mentions.twig
cp config_files/vagrant/cortext-auth/server/views/credits.twig cortext-auth/server/views/credits.twig
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

sudo sed -i 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen

echo "# Default locale for the system environment:
# Choices: None, en_US.UTF-8, fr_FR.UTF-8
locales locales/default_environment_locale      select  fr_FR.UTF-8
# Locales to be generated:
locales locales/locales_to_be_generated multiselect     en_US.UTF-8 UTF-8, fr_FR.UTF-8 UTF-8" > /home/vagrant/tmp_locales.txt
sudo debconf-set-selections /home/vagrant/tmp_locales.txt
rm /home/vagrant/tmp_locales.txt

sudo dpkg-reconfigure --frontend=noninteractive locales


tput setab 7; tput setaf 1;echo "8. Téléchargement des dépendances PHP$(tput sgr 0)"

#Les modules Cortext se basent sur des modules PHP qu'il faut récupérer de manière automatique grâce à Composer. Chemin à adapter en fonction de l'emplacement des modules Cortext. Cette étape peut être un peu longue.

cd /vagrant/cortext-auth/server
COMPOSER_PROCESS_TIMEOUT=4000 composer update --prefer-dist

cd /vagrant/cortext-assets/server
composer update

cd /vagrant/cortext-manager
composer update


tput setab 7; tput setaf 1;echo "9. Finalisation des BDD$(tput sgr 0)"
tput setab 7; tput setaf 1;echo "9.1 Reconstruction des BDD$(tput sgr 0)"
cd /vagrant/cortext-auth/server/data
php rebuild_db.php

tput setab 7; tput setaf 1;echo "9.2 Creation des vues$(tput sgr 0)"
mysql -u root ct_manager < /vagrant/scripts_sql/views_cortext.sql


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


tput setab 7; tput setaf 1;echo "12 Installation des scripts$(tput sgr 0)"
cd /vagrant/cortext-methods
sudo ./install-scripts.sh
tar xzf /vagrant/lib/lib_rickshaw_media.tar.gz -C /vagrant/cortext-methods/
tar xzf /vagrant/lib/mapexplorer.tar.gz -C /vagrant/cortext-methods/lib/
ln -s /vagrant/cortext-methods/lib/ /vagrant/cortext-assets/server/documents/lib


tput setab 7; tput setaf 1;echo "13 Dummy Data$(tput sgr 0)"
tput setab 7; tput setaf 1;echo "13.1 Insertion dans ct_auth$(tput sgr 0)"
mysql ct_auth -u root < /vagrant/dummy-data/users.sql

tput setab 7; tput setaf 1;echo "13.2 Insertion dans ct_manager$(tput sgr 0)"
mysql ct_manager -u root < /vagrant/dummy-data/job.sql

tput setab 7; tput setaf 1;echo "13.3 Insertion dans ct_assetsr$(tput sgr 0)"
mysql ct_assets -u root < /vagrant/dummy-data/document.sql

tput setab 7; tput setaf 1;echo "13.4 Telechargement des corpus$(tput sgr 0)"
wget https://file.cortext.net/files/dummy-assets.tar.gz -O /vagrant/dummy-data/dummy-assets.tar.gz

tput setab 7; tput setaf 1;echo "13.5 Decompression des corpus$(tput sgr 0)"
tar xzf /vagrant/dummy-data/dummy-assets.tar.gz -C /vagrant/cortext-assets/server/documents/
rm /vagrant/dummy-data/dummy-assets.tar.gz

tput setab 7; tput setaf 1;echo "13.6 Restauration de la base Meteor$(tput sgr 0)"
/vagrant/dummy-data/mongorestore -h 127.0.0.1 --port 3001 --drop -d meteor /vagrant/dummy-data/dump/meteor
# dump obtenu par la commande:
# ./mongodump -h 127.0.0.1 --port 3001 -d meteor


tput setab 7; tput setaf 1;echo "14 Fin$(tput sgr 0)"
cd
sudo service apache2 restart
supervisord -u vagrant -q /vagrant/log/supervisor
echo "Rebooter la machine virtuelle via les commandes suivantes:"
echo "exit"
echo "vagrant reload"
echo "Puis acceder à la page web http://10.10.10.10:3000"
