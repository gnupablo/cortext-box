#/bin/sh

# Creation de 2 users avec pour mdp vagrant

home_dir=/vagrant
cd $home_dir

echo -e "\e[1;32m=== Création du script SQL des données de test\e[0m"
echo "USE ct_auth;
INSERT INTO \`users\` (\`id\`, \`email\`, \`password\`, \`salt\`, \`roles\`, \`name\`, \`time_created\`) VALUES (1, 'vagrant@cortext.dev', 'AFBPhd+cjg65rjoId5Y9qGrOCT6Vx1WW5Ej9nb+GOqAU+KrxD/UgLFLj8e+7RBtkUa5hkRCmMAkDKZHc34245A==', '91dafk6473gokgc8w4kooko4sko0kwk', 'ROLE_USER', 'Test', 1417712225);
INSERT INTO \`users\` (\`id\`, \`email\`, \`password\`, \`salt\`, \`roles\`, \`name\`, \`time_created\`) VALUES (2, 'root@cortext.dev', 'AFBPhd+cjg65rjoId5Y9qGrOCT6Vx1WW5Ej9nb+GOqAU+KrxD/UgLFLj8e+7RBtkUa5hkRCmMAkDKZHc34245A==', '91dafk6473gokgc8w4kooko4sko0kwk', 'ROLE_ADMIN', 'Root', 1417712226);
INSERT INTO \`users_infos\` (\`user_id\`, \`description\`, \`location\`, \`website\`, \`birthdate\`, \`last_connexion\`) VALUES (1, '', 'Marseille, France', 'http://www.google.fr', '0000-00-00', '2014-12-27 15:32:58');
INSERT INTO \`users_infos\` (\`user_id\`, \`description\`, \`location\`, \`website\`, \`birthdate\`, \`last_connexion\`) VALUES (2, 'Une petite description', 'Paris, France', 'http://www.google.fr', '0000-00-00', '2015-01-27 15:32:58');" > tmp.sql

# user : vagrant@cortext.dev / vagrant
# admin : root@cortext.dev / vagrant

mysql -uroot << EOF
source tmp.sql;
EOF

echo -e "\e[1;32m=== Suppression du script SQL\e[0m"
if [ -f tmp.sql ]
then
   rm tmp.sql
fi

echo -e "\e[1;32m=== Fin\e[0m"
cd $home_dir
