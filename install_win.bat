echo "3. Récupération des sources depuis GitHub"

echo "3.1 Cortext-auth"
git clone --recursive git@github.com:cortext/cortext-auth.git

echo "3.2 Silex-simpleuser"
cd cortext-auth/server/vendor/cortext/silex-simpleuser
git checkout master
cd ../../../../..

echo "3.3 Cortext-assets"
git clone --recursive git@github.com:cortext/cortext-assets.git

echo "3.4 Cortext-manager"
git clone --recursive git@github.com:cortext/cortext-manager.git

echo "3.5 Cortext-projects"
git clone --recursive git@github.com:cortext/cortext-projects.git

echo "3.6 Cortext-methods"
git clone --recursive git@github.com:cortext/cortext-methods.git

echo "Rappel de l'ajout dans le DNS local"
echo MsgBox ^"Ne pas oublier d'ajouter la ligne suivante :^" ^& Chr(10) ^& Chr(10) ^& ^"127.0.0.1 auth.cortext.dev assets.cortext.dev cortext.dev www.cortext.dev documents.cortext.dev manager.cortext.dev^" ^& Chr(10) ^& Chr(10)^& ^"dans le fichier c:\windows\system32\drivers\etc\hosts^" > tmpscript.vbs
cscript tmpscript.vbs
del tmpscript.vbs

echo "4. Téléchargement de la machine virtuelle"
echo "Une fois la machine virtuelle démarrée, lancer la suite de l'exécution par la commande suivante:"
echo "install_inside.sh"
vagrant up
vagrant ssh
