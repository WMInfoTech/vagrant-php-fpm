# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "wmit/trusty64"
  config.vm.box_check_update = "true"

  config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
  config.vm.synced_folder 'webroot', '/var/www/vagrant.localhost', :owner => 'www-data'

  config.vm.provision "shell", path: "https://gist.githubusercontent.com/pcfens/66b4a4514949259cbf43/raw/930c4fa2fbcc10fb83410611ec1b6c65fcadee98/init.sh"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "site.pp"
    puppet.options = [
      "--pluginsync"
    ]
  end
end
