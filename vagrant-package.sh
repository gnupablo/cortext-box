#!/bin/sh
# Script de génération d'un package contenant l'état actuel de la box, plus push sur le serveur de fichier Cortext

# Gestion du suffixe de l'archive, si un paramètre est passé au script, il remplace le timestamp
if [ "$1" == "" ]
then
  suff=`date +%Y%m%d-%H%M%S`
else
  suff=$1
fi

# Génération du package
vagrant package default virtualbox --output cortext-jessie-docker-$suff.box

# Push du package sur le serveur de stockage
scp cortext-jessie-docker-$suff.box adminlisis@lisis-srv-prod.u-pem.fr:/srv/local/web/file.inra-ifris.org/files/
