#!/bin/sh
rm cortext.box
vagrant package default virtualbox --output cortext.box
scp cortext.box admifris@srvifris:/srv/local/web/webroot/public/upload/web/files/