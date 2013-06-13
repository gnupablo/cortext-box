Cortext Box
===========

Installation on linux Ubuntu (12.04+)
-------------------------------------

> note : do **not** install the repo versions : you may have some issues whith them

You will need 1Go of free disk space and 1Go of free RAM, in order to run the VM.

   * download and install Vagrant 1.1.5 package here http://downloads.vagrantup.com/tags/v1.1.5
   * install the linux kernel headers
   
```
sudo apt-get install linux-headers-`uname -r`
```

   * download and install Virtualbox 4.2 package here https://www.virtualbox.org/wiki/Downloads
   * reboot your machine (to properly start up the kernel modules)
   * you may have to change the bios configuration and turn the hardware virtualization on, in order to run virtual machines (see for example http://blog.darwin-it.nl/2012/04/bios-settings-for-virtualbox.html for details )

Then execute these instructions to put the vagrant file on /home/<user>/cortext-box :

    $ mkdir ~/cortext-box
    $ cd ~/cortext-box
    $ git clone --recursive git@github.com:cortext/cortext-box.git
    $ vagrant up

That's it !

Usage
-----

  * The document root for web projects is  ~/cortext-box/src/cortext
  * The VM apache web server is accessible at http://192.168.100.100
  * Use `vagrant ssh` to log into the VM
  * Use `vagrant halt` to shut it down
  * You can modify the parameters in the file ~/cortext-box/vagrant.conf

# Run Cortext projects

The /src/cortext/ directory contains remote git sub modules wich points to cortext projects.
Current Projects :
  * `/cortext-auth` : Auth server (build on top of oAuth2) and user manager (in php with symfony/silex)
  * `/cortext-assets` :  Assets server (ie files, directories, analysis, ...)
  * `/cortext-manager` : Core job manager and script launcher interface

To be commited :
  * `/cortext-dashboard` : Simple web app to navigate within scripts, assets, and view results of your analysis
  * `/cortext-project` : Complete web app to manage collaborative work and projects

## Default config (nginx and port forwarding)

 By default, the IP `192.168.100.100` redirects to /src/cortext and any php is interpreted by *nginx* (apache config is also available in the `puppet/modules/apache` subfolder, see bellow)

 The diferent projects are accessible directly with thess special ports (default 80 is set to dashboard for now) :
   * http://192.168.100.100       -> `auth + manager + dashboard / v2-alpha`
   * http://192.168.100.100:29100 -> `auth`
   * http://192.168.100.100:29200 -> `assets`
   * http://192.168.100.100:29300 -> `manager v2`   
   * http://192.168.100.100:29400 -> `dashboard v2`      
   * http://192.168.100.100:29500 -> `graphs`
   * http://192.168.100.100:29500 -> `supervisor (workers status)`


# Apache vhost
If you want to do things with apache instead of nginx, you can change the corresponding line in puppet/manifests/default.pp : 
uncomment  `apache` and comment `nginx` line. This will install apache when you restart the vagrant box (`vagrant halt` and `vagrant up`)

To allow apache to redirect correctly to the different projects, edit your `/etc/hosts` file and add the following line (assuming you did not change the IP in vagrant.conf file) : 

    $ 192.168.100.100 cortext.dev ct-auth.dev

The projects are now available at http://cortext.dev (web root) and http://ct-auth.dev (cortext auth)

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
Yes, you just have to edit the `vagrant.conf` file in the root folder.




