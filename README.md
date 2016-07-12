Cortext Box
===========

## git configuration on Windows

On Windows, assuming that git is already installed on you're configuration, you need to configure git to manage correctly symbolic links and line feeds, in a shell window, with the commands :

    git config --global core.symlinks true
    git config --global core.autocrlf input
    
These parameters can also be directly modified in the config file c:\ProgramData\Git\config, in the core section, like this:

    [core]
        symlinks = false
        autocrlf = input

## install virtualbox

- on ubuntu, just follow the chapter 1 of [INSTALL.txt](https://github.com/cortext/cortext-box/blob/master/INSTALL.txt)
- on windows, install the [virtual box package](https://www.virtualbox.org/wiki/Downloads) for your platform

## install vagrant

- [install vagrant on ubuntu](https://github.com/cortext/cortext-box/wiki/vagrant:-installation-on-ubuntu)
- [install vagrant on osx]()
- [install vagrant on Windows](https://www.vagrantup.com/downloads.html)

## Bootstrap the Cortext Box on Linux !

Then execute these instructions to put the vagrant file on `/home/<user>/boxes/cortext-box`. Do the addition to /etc/hosts only once, if you install multiple boxes.

    $ mkdir ~/boxes
    $ cd ~/boxes
    $ git clone --recursive git@github.com:cortext/cortext-box.git
    $ cd cortext-box
    $ ./install.sh
    $ install_inside.sh 
    $ exit
    $ echo "127.0.0.1 auth.cortext.dev assets.cortext.dev cortext.dev www.cortext.dev documents.cortext.dev manager.cortext.dev" | sudo tee --append /etc/hosts > /dev/null
    $ vagrant reload

That's it !

You can go to http://10.10.10.10:3000

## Bootstrap the Cortext Box on Windows !

Open an administrator shell window and go to the directory where you want to install cortext-box. Then execute these instructions. Do the addition to c:/windows/system32/drivers/etc/hosts only once, if you install multiple boxes.

    $ git clone --recursive git@github.com:cortext/cortext-box.git
    $ cd cortext-box
    $ install_win.bat
    $ install_inside.sh 
    $ exit
    $ echo 127.0.0.1       auth.cortext.dev assets.cortext.dev cortext.dev www.cortext.dev documents.cortext.dev manager.cortext.dev >> c:/windows/system32/drivers/etc/hosts
    $ vagrant reload

That's it !

You can go to http://127.0.0.1:3000

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

