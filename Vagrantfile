# -*- mode: ruby -*-
# vi: set ft=ruby :

# loading config
vgconfig = File.expand_path("../vagrant.conf", __FILE__)
load vgconfig

Vagrant.configure("2") do |config|
  # Box name
  config.vm.box = $base_box

  # Url to fetch the base box
  config.vm.box_url = $base_url

  # Box IP
  config.vm.network :private_network, ip: $ip
  
  config.vm.network :forwarded_port, guest: 29100, host: 29100 #auth
  config.vm.network :forwarded_port, guest: 29200, host: 29200 #assets
  config.vm.network :forwarded_port, guest: 29300, host: 29300 #manager
  config.vm.network :forwarded_port, guest: 29400, host: 29400 #dashboard
  config.vm.network :forwarded_port, guest: 29500, host: 3000 #graphs

  

  # Box config
  config.vm.provider :virtualbox do |vb|
     vb.customize ["modifyvm", :id, "--memory", "1024"]
   end
  #config.vm.share_folder $vhost, "/srv/web/vhosts/" + $vhost + ".dev", "../", :nfs => $use_nfs
  #config.vm.provider "virtualbox" do |v|
  #  v.gui = true
  #end

  # Puppet provisioner
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path      = "puppet/manifests"
    puppet.manifest_file       = "default.pp"
    puppet.module_path         = "puppet/modules"
    puppet.facter              = {
                                    "vhost" => $vhost
                                 } 
  end

end
