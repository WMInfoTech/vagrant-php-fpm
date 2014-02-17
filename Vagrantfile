# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "saucy64-wmit"
  config.vm.box_url = "http://mirror.swem.wm.edu/vagrant/saucy64-wmit.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
  config.vm.synced_folder 'webroot', '/var/www/vhosts/vagrant.localhost', :owner => 'www-data'

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "site.pp"
    puppet.facter = {
      "vagrant" => "1"
    }
    puppet.options = [
      "--pluginsync"
    ]
  end
end
