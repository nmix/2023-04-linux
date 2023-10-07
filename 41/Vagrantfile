# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |v|
    v.memory = 1024
    v.cpus = 1
  end

  config.vm.define "edge" do |server|
    server.vm.box = "generic/centos8s"
    server.vm.box_version = "4.2.16"
    server.vm.network "private_network", ip: "192.168.56.10"
    server.vm.provision :ansible do |ansible|
      ansible.playbook = "ansible/edge.yaml"
    end
  end
  
  config.vm.define "worker" do |server|
    server.vm.box = "generic/centos8s"
    server.vm.box_version = "4.2.16"
    server.vm.network "private_network", ip: "192.168.56.11"
    server.vm.provision :ansible do |ansible|
      ansible.playbook = "ansible/worker.yaml"
    end
  end
end
