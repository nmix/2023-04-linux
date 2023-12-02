# -*- mode: ruby -*-
# vim: set ft=ruby :

BOX_NAME = "generic/centos8s"
BOX_VERSION = "4.2.16"

MACHINES = {
  blnc: {
    networks: [
      { ip: "192.168.1.10",  adapter: 2, netmask: "255.255.255.0", virtualbox__intnet: "dmz-net" },
      { ip: "192.168.56.10", adapter: 8 },
    ]
  },
  app1: {
    networks: [
      { ip: "192.168.1.31", adapter: 2, netmask: "255.255.255.0", virtualbox__intnet: "dmz-net" },
      { ip: "192.168.56.31", adapter: 8 },
    ],
  },
  app2: {
    networks: [
      { ip: "192.168.1.32", adapter: 2, netmask: "255.255.255.0", virtualbox__intnet: "dmz-net" },
      { ip: "192.168.56.32", adapter: 8 },
    ],
  },
  fw: {
    networks: [
      { ip: "192.168.1.101",  adapter: 2, netmask: "255.255.255.0", virtualbox__intnet: "dmz-net" },
      { ip: "10.10.1.101",    adapter: 3, netmask: "255.255.255.0", virtualbox__intnet: "internal" },
      { ip: "192.168.56.101", adapter: 8 },
    ],
  },
  db1: {
    networks: [
      { ip: "10.10.1.131",    adapter: 2, netmask: "255.255.255.0", virtualbox__intnet: "internal"},
      { ip: "192.168.56.131", adapter: 8 },
    ],
  },
  db2: {
    networks: [
      { ip: "10.10.1.132",    adapter: 2, netmask: "255.255.255.0", virtualbox__intnet: "internal"},
      { ip: "192.168.56.132", adapter: 8 },
    ],
  },
  fs: {
    networks: [
      { ip: "10.10.1.141",    adapter: 2, netmask: "255.255.255.0", virtualbox__intnet: "internal"},
      { ip: "192.168.56.141", adapter: 8 },
    ],
  },
  nfs: {
    networks: [
      { ip: "10.10.1.142",    adapter: 2, netmask: "255.255.255.0", virtualbox__intnet: "internal"},
      { ip: "192.168.56.142", adapter: 8 },
    ],
  },
  obs: {
    networks: [
      { ip: "10.10.1.143",    adapter: 2, netmask: "255.255.255.0", virtualbox__intnet: "internal"},
      { ip: "192.168.56.143", adapter: 8 },
    ],
  },
}


Vagrant.configure("2") do |config|
  MACHINES.each_with_index do |(boxname, boxconfig), index|
    config.vm.define boxname do |box|
      box.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 1
      end
      box.vm.box = BOX_NAME
      box.vm.box_version = BOX_VERSION
      box.vm.host_name = boxname.to_s

      boxconfig[:networks].each do |ipconf|
        box.vm.network "private_network", **ipconf
      end

      # --- НЕ запускаем автоматом, т.к. плейбук отрабатывает, если поднять
      #     одну ВМ obs
      # # --- ansible запускаем после запуска всех машин из MACHINES
      # #     для запуска индивидуальных плейбуков необходимо использовать
      # #     команду:
      # #     ansible-playbook -i ansible/hosts ansible/playbook-name.yaml
      # if index == (MACHINES.length - 1)
      #   box.vm.provision "ansible" do |ansible|
      #     ansible.playbook = "ansible/provision.yaml"
      #     ansible.inventory_path = "ansible/hosts"
      #     ansible.host_key_checking = "false"
      #     ansible.vault_password_file = "ansible/vault_pass"
      #     ansible.limit = "all"
      #   end
      # end
    end
  end
end
