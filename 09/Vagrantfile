# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/centos8s"
  config.vm.box_version = "4.2.16"

  config.vm.provision "shell", inline: <<-SHELL
    yum install -y vim tmux
  SHELL
end
