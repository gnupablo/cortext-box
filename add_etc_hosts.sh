#/bin/sh

if [ `id -u -n` != 'root' ]
then
   echo -e "\e[1;31m=== Il faut avoir les droits root pour executer ce script\e[0m"
else
   echo -e "\e[1;32m=== Ajout des noms de domaines locaux à /etc/hosts\e[0m"

   echo "127.0.0.1	auth.cortext.dev" >> /etc/hosts
   echo "127.0.0.1	assets.cortext.dev" >> /etc/hosts
   echo "127.0.0.1	cortext.dev" >> /etc/hosts
   echo "127.0.0.1	www.cortext.dev" >> /etc/hosts
fi
