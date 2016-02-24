#!/bin/sh
vagrant package default virtualbox --output cortext-jessie-docker-$1.box
scp cortext-jessie-docker-$1.box adminlisis@lisis-srv-prod.u-pem.fr:/srv/local/web/file.inra-ifris.org/files/
