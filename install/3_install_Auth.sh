#!/bin/sh

home_dir=/vagrant

echo -e "\e[1;32m=== Recuperation des mots de passe de la BDD\e[0m"
stty -echo
printf "MySQL Root Password: "
read mdp_root
echo
printf "Define MySQL Auth User Password: "
read mdp_user
stty echo
echo

echo -e "\e[1;32m=== Création de la base de données\e[0m"
if [ -z $mdp_root ]
then 
mysql -uroot << EOF
CREATE DATABASE IF NOT EXISTS ct_auth;
USE ct_auth;
GRANT ALL PRIVILEGES ON ct_auth.* TO 'ct_auth'@'localhost' IDENTIFIED BY '$mdp_user' WITH GRANT OPTION;
EOF
else
mysql -uroot -p$mdp_root << EOF
CREATE DATABASE IF NOT EXISTS ct_auth;
USE ct_auth;
GRANT ALL PRIVILEGES ON ct_auth.* TO 'ct_auth'@'localhost' IDENTIFIED BY '$mdp_user' WITH GRANT OPTION;
EOF
fi

echo -e "\e[1;32m=== Création du fichier de paramètres du module Auth\e[0m"
echo "{
  \"client_id\": \"demoapp\",
  \"client_secret\": \"demopass\",
  \"token_route\": \"grant\",
  \"authorize_route\": \"authorize\",
  \"resource_route\": \"access\",
  \"resource_method\": \"GET\",
  \"resource_params\": {},
  \"curl_options\": {},
  \"db_options\": {
       \"driver\" : \"pdo_mysql\",
       \"dbname\" : \"ct_auth\",
       \"host\" : \"localhost\",
       \"user\" : \"ct_auth\",
       \"password\" : \"$mdp_user\"
    },
    \"oauth\": {
    \"access_lifetime\": 31536000
    },
    \"mailer\": {
      \"host\"       : \"\",
      \"port\"       : 0,
      \"username\"   : \"\",
      \"password\"   : \"\",
      \"encryption\" : \"\",
      \"auth_mode\"  : \"\"
    }
}" > $home_dir/cortext-auth/server/data/parameters.json

echo -e "\e[1;32m=== Téléchargement des modules via composer\e[0m"
cd $home_dir/cortext-auth/server
COMPOSER_PROCESS_TIMEOUT=4000 composer update --prefer-dist

echo -e "\e[1;32m=== Appel de la construction de la BDD\e[0m"
cd $home_dir/cortext-auth/server/data
php rebuild_db.php

echo -e "\e[1;32m=== Configuration du VHost\e[0m"
sudo cp /vagrant/auth.conf /etc/apache2/sites-available/auth.conf
sudo a2ensite auth.conf
sudo service apache2 reload

echo -e "\e[1;32m=== Initialisation du fichier de log\e[0m"
sudo touch $home_dir/cortext-auth/server/log/ctauth.log

echo -e "\e[1;32m=== Modification des droits du répertoire log\e[0m"
sudo chmod g+w $home_dir/cortext-auth/server/log/ctauth.log

echo -e "\e[1;32m=== Fin\e[0m"
cd $home_dir
