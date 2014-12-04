#/bin/sh

echo -e "\e[1;32m=== Script d'installation de la machine virtuelle\e[0m"

# A executer sur la machine virtuelle une fois qu'elle aura été initialisée

echo -e "\e[1;32m=== Mise à jour de la machine virtuelle\e[0m"
sudo apt-get update
sudo apt-get -y --force-yes upgrade

echo -e "\e[1;32m=== Installation des packages nécessaires à Cortext\e[0m"
sudo apt-get install -y --force-yes apache2 php5 php5-mysql mysql-server phpmyadmin libapache2-mod-wsgi libapache2-mod-php5 mysql-client php-pear curl php5-cli php5-dev php5-gd php5-curl php5-intl git

echo -e "\e[1;32m=== Activation des modules apache\e[0m"
sudo a2enmod rewrite headers

echo -e "\e[1;32m=== Modification du groupe d'exécution apache\e[0m"
sudo sed -i 's/export APACHE_RUN_GROUP=www-data/export APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars

echo -e "\e[1;32m=== On permet un mot de passe vide pour la BDD\e[0m"
sudo sed -i "s/\/\/ \$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE/\$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE/" /etc/phpmyadmin/config.inc.php

echo -e "\e[1;32m=== Modification du umask Apache\e[0m"
sudo echo "umask 0002" >> /etc/apache2/envvars

echo -e "\e[1;32m=== Redémarrage d'Apache pour prendre en compte la nouvelle config\e[0m"
sudo service apache2 restart

echo -e "\e[1;32m=== Téléchargement de Composer\e[0m"
cd
curl -s https://getcomposer.org/installer | php

echo -e "\e[1;32m=== Création d'un lien vers Composer\e[0m"
sudo ln -s /home/vagrant/composer.phar /usr/local/bin/composer

echo -e "\e[1;32m=== Création des alias\e[0m"
sudo echo "export LS_OPTIONS='--color=auto'" >> /home/vagrant/.bash_aliases
sudo echo "eval \"`dircolors`\"" >> /home/vagrant/.bash_aliases
sudo echo "alias ls='ls \$LS_OPTIONS'" >> /home/vagrant/.bash_aliases
sudo echo "alias ll='ls \$LS_OPTIONS -lrth'" >> /home/vagrant/.bash_aliases
sudo echo "alias la='ls \$LS_OPTIONS -lA'" >> /home/vagrant/.bash_aliases
sudo echo "alias l='ls \$LS_OPTIONS -l'" >> /home/vagrant/.bash_aliases
. /home/vagrant/.bash_aliases
 
#sudo echo "export LS_OPTIONS='--color=auto'" >> /root/.bashrc
#sudo echo "eval \"`dircolors`\"" >> /root/.bashrc
#sudo echo "alias ls='ls $LS_OPTIONS'" >> /root/.bashrc
#sudo echo "alias ll='ls $LS_OPTIONS -lrth'" >> /root/.bashrc
#sudo echo "alias la='ls $LS_OPTIONS -lA'" >> /root/.bashrc
#sudo echo "alias l='ls $LS_OPTIONS -l'" >> /root/.bashrc

echo -e "\e[1;32m=== Appels des scripts d'installation des modules Cortext\e[0m"
cd /vagrant
. 3_install_Auth.sh
. 4_install_Assets.sh
. 5_install_Manager.sh

echo -e "\e[1;32m=== Il ne reste plus qu'à configurer les redirections locales\e[0m"
echo -e "\e[1;31mExecuter avec les droits root ./add_etc_hosts.sh\e[0m"
echo -e "\e[1;31msur la machine virtuelle et sur la machine physique\e[0m"
