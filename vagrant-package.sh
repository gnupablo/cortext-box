#!/bin/sh
#rm cortext.box
vagrant package default virtualbox --output cortext-jessie-docker-$1.box
scp cortext-jessie-docker-$1.box admifris@srvifris:/srv/local/web/webroot/public/upload/web/files/
