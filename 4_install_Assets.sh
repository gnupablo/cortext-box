#/bin/sh

home_dir=/vagrant

echo -e "\e[1;32m=== Création du script SQL de création de la base\e[0m"
echo "CREATE DATABASE IF NOT EXISTS ct_assets;
USE ct_assets;
GRANT ALL PRIVILEGES ON ct_assets.* TO 'ct_assets'@'localhost' IDENTIFIED BY '' WITH GRANT OPTION;
CREATE TABLE IF NOT EXISTS \`document\` (
  \`hash\` varchar(256) NOT NULL COMMENT 'md5 du fullname (path+filename)',
  \`fullname\` text NOT NULL COMMENT 'path+filename reel',
  \`username\` varchar(128) DEFAULT NULL,
  PRIMARY KEY (\`hash\`),
  KEY \`username\` (\`username\`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;" > tmp.sql

mysql -uroot << EOF
source tmp.sql;
EOF

echo -e "\e[1;32m=== Suppression du script SQL\e[0m"
if [ -f tmp.sql ]
then
   rm tmp.sql
fi

echo -e "\e[1;32m=== Gestion des droits du répertoire log\e[0m"
touch $home_dir/cortext-assets/server/log/assets.log
chmod g+w $home_dir/cortext-assets/server/log/assets.log

echo -e "\e[1;32m=== Création du répertoire documents\e[0m"
mkdir -p $home_dir/cortext-assets/server/documents
chmod 777 $home_dir/cortext-assets/server/documents

echo -e "\e[1;32m=== Génération du fichier de config\e[0m"
echo "<?php
/* cortext assets config file */

//constants
define('CORPUS_EXTENSIONS','txt|csv|zip|db|html|htm');
define('ALL_DOCUMENTS','');
define('RESERVED_FILENAMES','MAIN_READLOCK|MAIN_WRITELOCK|log.txt|\.pkl|\.yml|\.yaml|^_.*');
//urls
define('URL_OAUTH_SERVER','http://auth.cortext.dev');
define('URL_MANAGER','http://manager.cortext.dev');
define('URL_FILES','http://documents.cortext.dev/');
//database
define('DB_DRIVER', 'pdo_mysql');
define('DB_HOST', 'localhost');
define('DB_DBNAME', 'ct_assets');
define('DB_USER', 'ct_assets');
define('DB_PASSWORD', '');
////////////////////////////////////////////////////
//Parameters Construction
\$parameters = array();
\$parameters['db_options']['driver'] = DB_DRIVER;
\$parameters['db_options'] = array(
    'driver' => DB_DRIVER,
    'host' => DB_HOST,
    'dbname' => DB_DBNAME,
    'user' => DB_USER,
    'password' => DB_PASSWORD
);" > $home_dir/cortext-assets/server/app/config.php
chmod 664 $home_dir/cortext-assets/server/app/config.php

echo -e "\e[1;32m=== Téléchargement des modules via composer\e[0m"
cd $home_dir/cortext-assets/server
composer update

echo -e "\e[1;32m=== Configuration du VHost\e[0m"
cp /vagrant/assets.conf /etc/apache2/sites-available/assets.conf
a2ensite assets.conf
service apache2 reload

echo -e "\e[1;32m=== Renommage du .htaccess\e[0m"
mv $home_dir/cortext-assets/server/web/.htaccess.default $home_dir/cortext-assets/server/web/.htaccess

echo -e "\e[1;32m=== Fin\e[0m"
cd $home_dir
