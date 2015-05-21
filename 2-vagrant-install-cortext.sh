#!/bin/sh
#config
sudo debconf-set-selections /vagrant/preconfig.txt 2> /dev/null

#package de base
sudo apt-get update
sudo apt-get install -y --force-yes apache2 php5 php5-mysql mysql-server phpmyadmin libapache2-mod-wsgi libapache2-mod-php5 mysql-client php-pear curl php5-cli php5-dev php5-gd php5-curl php5-intl postfix mailutils git python-setuptools htop atop nethogs nmap multitail

#composer
cd
curl -s https://getcomposer.org/installer | php
sudo ln -s /home/vagrant/composer.phar /usr/local/bin/composer

#phpUnit
cd
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
sudo mv phpunit.phar /usr/bin/phpunit

#zeroMQ
cd /vagrant/cortext-manager/src/Cortext/mcp
./install_zmq-v4.sh

#supervisor
cd
sudo easy_install supervisor

#Meteor
cd
curl https://install.meteor.com/ | sh

mkdir ~/.meteor_cortext_projects_local
ln -s ~/.meteor_cortext_projects_local/ /vagrant/cortext-projects/.meteor/local

