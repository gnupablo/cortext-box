Cortext Box
===========

## install vagrant

- [install vagrant on ubuntu](https://github.com/cortext/cortext-box/wiki/vagrant:-installation-on-ubuntu)
- [install vagrant on osx]()

## bootstrap the cortext-box !

Then execute these instructions to put the vagrant file on `/home/<user>/boxes/cortext-box`. Do the addition to /etc/hosts only once, if you install multiple boxes. (NB: If you're in windows, replace ./install.sh by install_win.bat)

    $ mkdir ~/boxes
    $ cd ~/boxes
    $ git clone --recursive git@github.com:cortext/cortext-box.git
    $ cd cortext-box
    $ ./install.sh
    $ install_inside.sh 
    $ exit
    $ echo "127.0.0.1 auth.cortext.dev assets.cortext.dev cortext.dev www.cortext.dev documents.cortext.dev" | sudo tee --append /etc/hosts > /dev/null
    $ vagrant reload

That's it !

You can go to http://10.10.10.10:3000

Usage
-----

  * The document root for web projects is  ~/cortext-box/src/cortext
  * The VM apache web server is accessible at http://10.10.10.10:8080
  * The VM Meteor Frontend is accessible at http://10.10.10.10:3000
  * Use `vagrant ssh` to log into the VM
  * Use `vagrant halt` to shut it down
  * Use `vagrant suspend` to hibernate it
  * Use `vagrant reload` to reboot it
  * Use `vagrant up` to start it
  * Use `vagrant destroy` to delete it
  * You can modify the parameters in the file ~/cortext-box/Vagrantfile

# Run Cortext projects

The /src/cortext/ directory contains remote git sub modules wich points to cortext projects.
Current Projects :
  * `/cortext-auth` : Auth server (build on top of oAuth2) and user manager (in php with symfony/silex)
  * `/cortext-assets` :  Assets server (ie files, directories, analysis, ...)
  * `/cortext-manager` : Core job manager and script launcher interface

To be commited :
  * `/cortext-dashboard` : Simple web app to navigate within scripts, assets, and view results of your analysis
  * `/cortext-project` : Complete web app to manage collaborative work and projects

FAQ 
---

> How do I remove my box completely ?

    $ vagrant destroy
    $ vagrant remove <name_of_the_box> virtualbox

This way the box will completly be removed from your system, including the virtual drives associate with it.
You can also remove the `.vagrant` folder from the project root directory to remove all traces of vagrant. 
When you want to start again, you juste have to `vagrant up` and you're ready to go. (See http://docs.vagrantup.com for details)

> How do I know the boxes I have installed ?

    $ `vagrant box list`

> Can I change the configuration of the box ?

Yes, you just have to edit the `Vagrantfile` file in the root folder.

