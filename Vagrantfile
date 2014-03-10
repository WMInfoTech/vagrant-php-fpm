# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "wmit/precise64"

  config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
  config.vm.synced_folder 'webroot', '/var/www/vagrant.localhost', :owner => 'www-data'

  $install_puppet_modules = <<SCRIPT
sudo gem install librarian-puppet --no-rdoc --no-ri
cd /vagrant/puppet
/usr/local/bin/librarian-puppet install
SCRIPT

  config.vm.provision "shell", inline: $install_puppet_modules

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
