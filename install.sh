#!/bin/sh

git clone --recursive git@github.com:cortext/cortext-auth.git
cd cortext-auth/server/vendor/cortext/silex-simpleuser
git checkout master
cd ../../../../..
git clone --recursive git@github.com:cortext/cortext-assets.git
git clone --recursive git@github.com:cortext/cortext-manager.git
git clone --recursive git@github.com:cortext/cortext-projects.git
git clone --recursive git@github.com:cortext/cortext-methods.git

vagrant up && vagrant ssh
