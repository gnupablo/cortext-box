#/bin/sh

# Ce script permet de créer des utilisateurs de test pour obtenir dès 
# l'installation un environnement fonctionnel avec deux utilisateurs.
#
# Un profil utilisateur :
#   login : vagrant@cortext.dev
#   mdp : vagrant
#
# Un profil administrateur :
#   login : root@cortext.dev
#   mdp : vagrant
#
# Ils correspondent aux deux utilisateurs créés sur l'environnement vagrant.
#
# La configuration de postfix dans les étapes précédentes fait que les
# mails envoyés à ces utilisateurs sont envoyés en local et donc 
# accessibles via la commande mail dans un terminal depuis le compte utilisateur
# correspondant.

# Définition du répertoire de travail
home_dir=/vagrant
cd $home_dir

# Création du script SQL pour insertion des données de test en base
echo -e "\e[1;32m=== Création du script SQL des données de test\e[0m"
echo "USE ct_auth;
INSERT INTO \`users\` (\`id\`, \`email\`, \`password\`, \`salt\`, \`roles\`, \`name\`, \`time_created\`) VALUES (1, 'vagrant@cortext.dev', 'AFBPhd+cjg65rjoId5Y9qGrOCT6Vx1WW5Ej9nb+GOqAU+KrxD/UgLFLj8e+7RBtkUa5hkRCmMAkDKZHc34245A==', '91dafk6473gokgc8w4kooko4sko0kwk', 'ROLE_USER', 'Test', 1417712225);
INSERT INTO \`users\` (\`id\`, \`email\`, \`password\`, \`salt\`, \`roles\`, \`name\`, \`time_created\`) VALUES (2, 'root@cortext.dev', 'AFBPhd+cjg65rjoId5Y9qGrOCT6Vx1WW5Ej9nb+GOqAU+KrxD/UgLFLj8e+7RBtkUa5hkRCmMAkDKZHc34245A==', '91dafk6473gokgc8w4kooko4sko0kwk', 'ROLE_ADMIN', 'Root', 1417712226);
INSERT INTO \`users_infos\` (\`user_id\`, \`description\`, \`location\`, \`website\`, \`birthdate\`, \`last_connexion\`) VALUES (1, '', 'Marseille, France', 'http://www.google.fr', '0000-00-00', '2014-12-27 15:32:58');
INSERT INTO \`users_infos\` (\`user_id\`, \`description\`, \`location\`, \`website\`, \`birthdate\`, \`last_connexion\`) VALUES (2, '', 'Paris, France', 'http://www.google.fr', '', '');" > tmp.sql

# user : vagrant@cortext.dev / vagrant
# admin : root@cortext.dev / vagrant

# Execution du script SQL
mysql -uroot << EOF
source tmp.sql;
EOF

# Suppression du script SQL
echo -e "\e[1;32m=== Suppression du script SQL\e[0m"
if [ -f tmp.sql ]
then
   rm tmp.sql
fi

# FIN
echo -e "\e[1;32m=== Fin\e[0m"
cd $home_dir
