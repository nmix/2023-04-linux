# 01. С чего начинается Linux

## Manual kernel upgrade

Создаем Vagrantfile из методички, меняем *centos/stream8:20210210.0* на *generic/centos8s:4.2.16*, т.к. версия из методички выдает 404.

Включаем vpn

```bash
vagrant up
```

Выключаем vpn

Запускаем виртуальную машину и смотрим текущее ядро
```bash
vagrant ssh
uname -r
#=> 4.18.0-448.el8.x86_64
```

Обновляем ядро и проверяем версию
```bash
sudo yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
sudo yum --enablerepo elrepo-kernel install kernel-ml -y

sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo grub2-set-default 0
sudo reboot

vagrant ssh
uname -r
#=> 6.3.0-1.el8.elrepo.x86_64
```

## Create image with packer

Создаем структуру каталогов и файлов из методички

```bash
packer/
├── centos.json
├── http
│   └── ks.cfg
├── scripts
│   ├── stage-1-kernel-update.sh
│   └── stage-2-clean.sh
```

Важные моменты:

1) В файле *centos.json* изменяем параметр `ssh_timout` на `ssh_timout: 30m`, т.к. установка может затянуться. Если срабатоает таймаут, то packer прервет установку и удалит ВМ.

2) В разделе `provisioners` файла *centros.json* изменяем значение `execute_command` на `"execute_command":  "echo 'vagrant' | sudo -S -E bash '{{.Path}}'"`. Это необходимо, чтобы выполнение предустановочных сценариев не зависало на ожидании пароля `sudo`.

3) Если исполнение второго скрипта *stage-2-clean.sh* зависнит на этапе `Gracefully halting`, можно просто выключить ВМ через VirtualBox и выполнение продолжится. Альтернативно можно во второй скрипт добавить команду `shutdown -r now` и перезаустить установку.

Запускаем установку

```bash
cd packer
packer build centos.json
```

При сборке откроется окно VirtualBox в котором надо будет задавать итерактивные команды, типа "продолжить установку" или "перезагрузить систему".

После завершения установки в текущем каталоге появится файл образа системы *centos-8-kernel-6-x86_64-Minimal.box*.

Для проверки запустим созданный образ:
```bash
vagrant box add centos8 centos-8-kernel-6-x86_64-Minimal.box
vagrant init centos8
vagrant up
vagrant ssh
uname -r
#=> 6.3.0-1.el8.elrepo.x86_64
exit
```

Удаляем ВМ
```bash
vagrant destroy --force
```

Выгружаем образ системы в облако Vagrant
```bash
vagrant cloud auth login
vagrant cloud publish --release zoid/centos8-kernel6 1.0 virtualbox centos-8-kernel-6-x86_64-Minimal.box
```

[Ссылка на образ](https://app.vagrantup.com/zoid/boxes/centos8-kernel6)

Для проверки где-нибудь в другой директории выполняем команды запуска новой ВМ с проверкой версии ядра.
```bash
vagrant init zoid/centos8-kernel6 --box-version 1.0
vagrant up
vagrant ssh
uname -r
```
