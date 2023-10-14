# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = [
  {
    :name => "master",
    :box_name => "centos/7",
    :box_version => "2004.01",
    :ip_addr => '192.168.56.150'
  },
  {
    :name => "slave",
    :box_name => "centos/7",
    :box_version => "2004.01",
    :ip_addr => '192.168.56.151'
  }
]

Vagrant.configure("2") do |config|

  MACHINES.each do |boxconfig|

    config.vm.define boxconfig[:name] do |box|

      box.vm.box = boxconfig[:box_name]
      box.vm.host_name = boxconfig[:name]

      box.vm.network "private_network", ip: boxconfig[:ip_addr]

      box.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "1024"]
      end

      box.vm.provision :shell do |s|
         s.inline = 'mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh'
      end

      box.vm.provision "ansible" do |ansible|
        ansible.inventory_path = "ansible/hosts"
        ansible.playbook = "ansible/provision.yaml"
      end
    end
  end
end
