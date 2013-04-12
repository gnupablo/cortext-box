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

  # Box config
  config.vm.provider :virtualbox do |vb|
     vb.customize ["modifyvm", :id, "--memory", "1024"]
   end
  #config.vm.share_folder $vhost, "/srv/web/vhosts/" + $vhost + ".dev", "../", :nfs => $use_nfs

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
