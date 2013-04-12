Cortext Box
===========

Installation on linux Ubuntu 12.10
----------------------------------

> note : do not install the repo versions

You will need 1Go of free disk space and 1Go of free RAM, in order to run the VM.

   * download and install Vagrant 1.1.5 package here http://downloads.vagrantup.com/tags/v1.1.5
   * download and install Virtualbox 4.2 package here https://www.virtualbox.org/wiki/Downloads
   * reboot your machine (to properly start up the kernel modules)

Then execute these instructions to put the vagrant file on /home/cortext  :

    $ mkdir ~/cortext
    $ cd ~/cortext
    $ git clone git@github.com:cortext/box.git 
    $ vagrant init cortext-box 
    $ vagrant up

That's it !

Usage
-----
  * The document root for apache is  ~/cortext/
  * The VM apache web server is accessible at http://localhost:8080
  * Use `vagrant ssh` to log into the VM
  * Use `vagrant halt` to shut it down

