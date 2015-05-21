#!/bin/sh
echo "8.8 Configuration de la locale\n"
echo "Dans la liste, sélectionner fr_FR.UTF-8 puis valider. Choisir ensuite la langue par défaut : fr_FR.UTF-8 et valider.\n"

#Il va falloir ajouter le fr_FR.UTF-8

sudo dpkg-reconfigure locales

echo "9 Téléchargement des dépendances PHP"

#Les modules Cortext se basent sur des modules PHP qu'il faut récupérer de manière automatique grâce à Composer. Chemin à adapter en fonction de l'emplacement des modules Cortext. Cette étape peut être un peu longue.

cd /vagrant
cd cortext-auth/server
COMPOSER_PROCESS_TIMEOUT=4000 composer update --prefer-dist

cd ../../cortext-assets/server
composer update

cd ../../cortext-manager
composer update

echo "10 Reconstruction des BDD"
#Le module Cortext-Auth possède un script de construction des tables de la base de données qui lui sont nécessaires.

cd /vagrant
cd cortext-auth/server/data
php rebuild_db.php

echo "11 Initialisation des fichiers log"
#Pour éviter un bug au lancement des modules, les fichiers logs sont créés s'ils n'existent pas déjà. Adapter les chemins en fonction de la configuration.

cd /vagrant
mkdir -p cortext-auth/server/log
touch cortext-auth/server/log/ctauth.log
touch cortext-assets/server/log/assets.log
mkdir -p cortext-manager/log

echo "12 Initialisation de l'arborescence"
#Création de répertoire manquant, nécessaire au fonctionnement de Cortext

cd /vagrant
mkdir -p cortext-assets/server/documents

echo "13 Activation des serveurs au démarrage"
#Pour que les serveurs soient exécutés directement au démarrage de la machine virtuelle, il faut lancer le script depuis le Vagrantfile. En production, il faudra utiliser une autre manière de démarrer les serveurs via supervisor.

cp /vagrant/Vagrantfile_Running /vagrant/Vagrantfile

echo "------------ Configuration terminée : veuillez sortir du terminal et rebooter la machine virtuelle------------------\n"
