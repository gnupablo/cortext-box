Cortext Box
===========

Installation on linux Ubuntu 12.10
----------------------------------

> note : do **not** install the repo versions : you may have some issues whith them

You will need 1Go of free disk space and 1Go of free RAM, in order to run the VM.

   * download and install Vagrant 1.1.5 package here http://downloads.vagrantup.com/tags/v1.1.5
   * download and install Virtualbox 4.2 package here https://www.virtualbox.org/wiki/Downloads
   * reboot your machine (to properly start up the kernel modules)

Then execute these instructions to put the vagrant file on /home/cortext  :

    $ mkdir ~/cortext-box
    $ cd ~/cortext-box
    $ git clone git@github.com:cortext/box.git
    $ vagrant up

That's it !

Usage
-----
  * The document root for apache is  ~/cortext-box/src
  * The VM apache web server is accessible at http://192.168.100.100
  * Use `vagrant ssh` to log into the VM
  * Use `vagrant halt` to shut it down
  * You can modify the parameters in the file ~/cortext-box/vagrant.conf

