#! /bin/sh

# Script exécuté au démarrage de la machine virtuelle ou physique
# Permet de lancer les serveurs qui ne sont pas lancés automatiquement

supervisord -u vagrant -q /var/log/supervisor
