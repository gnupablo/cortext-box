#/bin/sh

home_dir=/vagrant

echo -e "\e[1;32m=== Création de la base de données\e[0m"
mysql -uroot << EOF
CREATE DATABASE IF NOT EXISTS ct_auth;
USE ct_auth;
GRANT ALL PRIVILEGES ON ct_auth.* TO 'ct_auth'@'localhost' IDENTIFIED BY '' WITH GRANT OPTION;
EOF

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
       \"password\" : \"\"
    },
    \"oauth\": {
    \"access_lifetime\": 31536000
    },
    \"mailer\": {
      \"host\"       : \"localhost\",
      \"port\"       : 25,
      \"username\"   : \"\",
      \"password\"   : \"\",
      \"encryption\" : \"\",
      \"auth_mode\"  : \"\"
    },
    \"manager\" : \"http://manager.cortext.dev\"
}" > $home_dir/cortext-auth/server/data/parameters.json

echo -e "\e[1;32m=== Téléchargement des modules via composer\e[0m"
cd $home_dir/cortext-auth/server
COMPOSER_PROCESS_TIMEOUT=4000 composer update --prefer-dist

echo -e "\e[1;32m=== Appel de la construction de la BDD\e[0m"
cd $home_dir/cortext-auth/server/data
php rebuild_db.php

echo -e "\e[1;32m=== Configuration du VHost\e[0m"
cp /vagrant/auth.conf /etc/apache2/sites-available/auth.conf
a2ensite auth.conf
service apache2 reload

echo -e "\e[1;32m=== Initialisation du fichier de log\e[0m"
touch $home_dir/cortext-auth/server/log/ctauth.log

echo -e "\e[1;32m=== Modification des droits du répertoire log\e[0m"
chmod g+w $home_dir/cortext-auth/server/log/ctauth.log

echo -e "\e[1;32m=== Fin\e[0m"
cd $home_dir
