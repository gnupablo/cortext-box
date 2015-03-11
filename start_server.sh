#! /bin/sh

# Script exécuté au démarrage de la machine virtuelle ou physique
# Permet de lancer les serveurs qui ne sont pas lancés automatiquement

sudo service apache2 restart
supervisord -u vagrant -q /vagrant/log/supervisor
