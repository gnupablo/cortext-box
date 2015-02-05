#/bin/sh

home_dir=/vagrant

echo -e "\e[1;32m=== Création du script SQL de création de la base\e[0m"
echo "CREATE DATABASE IF NOT EXISTS ct_manager DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE ct_manager;
GRANT ALL PRIVILEGES ON ct_manager.* TO 'ct_manager'@'localhost' IDENTIFIED BY '' WITH GRANT OPTION;
CREATE TABLE IF NOT EXISTS \`job\` (
  \`id\` bigint(20) NOT NULL AUTO_INCREMENT,
  \`label\` varchar(255) DEFAULT NULL,
  \`script_path\` text,
  \`result_path\` text,
  \`log_path\` text,
  \`upload_path\` text,
  \`state\` bigint(20) NOT NULL DEFAULT '0',
  \`user_id\` bigint(20) NOT NULL,
  \`script_id\` bigint(20) NOT NULL,
  \`corpu_id\` bigint(20) NOT NULL,
  \`created_at\` datetime NOT NULL,
  \`updated_at\` datetime NOT NULL,
  \`document_path\` text COMMENT 'document hash',
  \`context\` text,
  PRIMARY KEY (\`id\`),
  KEY \`script_id_idx\` (\`script_id\`),
  KEY \`corpu_id_idx\` (\`corpu_id\`),
  KEY \`user_id_idx\` (\`user_id\`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;
CREATE TABLE IF NOT EXISTS \`script\` (
  \`id\` bigint(20) NOT NULL AUTO_INCREMENT,
  \`label\` varchar(255) NOT NULL,
  \`script_path\` text NOT NULL,
  \`user_id\` bigint(20) NOT NULL,
  \`ispublic\` tinyint(1) DEFAULT NULL,
  \`comment\` text,
  PRIMARY KEY (\`id\`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;" > tmp.sql

mysql -uroot << EOF
source tmp.sql;
EOF

echo -e "\e[1;32m=== Suppression du script SQL\e[0m"
if [ -f tmp.sql ]
then
   rm tmp.sql
fi

echo -e "\e[1;32m=== Peuplement de la table des scripts\e[0m"
if [ -f $home_dir/cortext-manager/data/table-script-datas.sql ]
then
   mysql -uroot << EOF
USE ct_manager;
source $home_dir/cortext-manager/data/table-script-datas.sql;
EOF
fi

echo -e "\e[1;32m=== Création et gestion des droits du répertoire log\e[0m"
mkdir -p $home_dir/cortext-manager/log
chmod -R g+w $home_dir/cortext-manager/log/

echo -e "\e[1;32m=== Génération du fichier de config\e[0m"
echo "{
  \"db_options\": {
         \"driver\" : \"pdo_mysql\",
         \"dbname\" : \"ct_manager\",
         \"host\" : \"localhost\",
         \"username\" : \"ct_manager\",
         \"password\" : \"\"
      },
  \"Scripts\" : {
        \"path\"  :  \"/vagrant/cortext-methods\"
  },
  \"Storage\": {
      \"name\": \"Cortext Assets\",
      \"api\": \"http://assets.cortext.dev\",
      \"url\": \"http://assets.cortext.dev:8080\",
      \"getDocument\": \"/docs\"
  },
  \"Identity\": {
      \"name\": \"Cortext Auth\",
      \"urlAuth\": \"http://auth.cortext.dev/auth\",
      \"urlAccess\": \"http://auth.cortext.dev/auth/access\",
      \"urlSubscribe\": \"http://auth.cortext.dev:8080/user/register\",
      \"urlEdit\": \"http://auth.cortext.dev:8080/user\",
      \"urlLogout\": \"http://auth.cortext.dev:8080/user/logout\",
      \"urlLogin\": \"http://auth.cortext.dev:8080/user/login\",
      \"account\": {
          \"service\": \"cortext\",
          \"clientId\": \"cortext-dashboard\",
          \"secret\": \"c0rt3xt\"
      }
  },   
  \"Api\": {
      \"url\": \"http://localhost:8080\",
      \"createElement\": \"/elements\",
      \"createDocument\": \"/documents\",
      \"createAnalysis\": \"/analysis\"
  },
  \"debug_mode\": true
}" > $home_dir/cortext-manager/data/parameters.json

echo -e "\e[1;32m=== Téléchargement des modules via composer\e[0m"
cd $home_dir/cortext-manager
composer update

echo -e "\e[1;32m=== Configuration du VHost\e[0m"
cp /vagrant/manager.conf /etc/apache2/sites-available/manager.conf
a2ensite manager.conf
service apache2 reload

echo -e "\e[1;32m=== Fin\e[0m"
cd $home_dir
