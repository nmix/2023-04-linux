# Проектная работа

Наименование проектой работы - *Развертывание Django CMS с помощью Vagrant и Ansible*

## Схема развертывания

> TODO

## План восстановления

### app1 / app2

`app1` и `app2` - серверы приложений. Здесь крутится web-контейнер cms.
На данном сервере данные не сохраняются, поэтому выполняем стандартный плейбук инициализации сервера

```bash
vagrant up app1
ansible-playbook -i ansible/hosts ansible/app.yaml
```

### fw

`fw` - firewall - сетевой экран между dmz и internal зонами сети.
Пропускает соединения только с хостов `app1` и `app2`.
Сервер является **точкой отказа**. 

```bash
vagrant up fw
ansible-playbook -i ansible/hosts ansible/fw.yaml
```

### nfs

`nfs` - Network File System сервер. Здесь расположены статические файлы приложения: картинки, видео, вложения и прочее.
Сервер является **точкой отказа**. 
Система не работает до восстановления данных из резервной копии.

```bash
vagrant up nfs
ansible-playbook -i ansible/hosts ansible/nfs-recover-latest.yaml
```

### db1

`db1` - мастер базы данных

#### Вариант 1. Master Recover

Предварительно должна быть сформирована резервная копия БД

```bash
vagrant up db1
ansible-playbook -i ansible/hosts ansible/firewalld-internal-config.yaml
ansible-playbook -i ansible/hosts ansible/database.yaml
ansible-playbook -i ansible/hosts ansible/barman.yaml
ansible-playbook -i ansible/hosts ansible/database-recover-latest.yaml -e master=db1 -e master_ip=10.10.1.131 -e slave=db2
```

#### Вариант 2. Slave -> Master

```bash
# --- возобновляем работу приложения
ansible-playbook -i ansible/hosts ansible/database-master-reinit.yaml -e target=db2 -e master_ip=10.10.1.132
# --- готовим новую реплику
vagrant up db1
ansible-playbook -i ansible/hosts ansible/database-slave-reinit.yaml -e target=db1 -e master=db2 -e master_ip=10.10.1.132
# ansible-playbook -i ansible/hosts ansible/switch-barman-on-another-master.yaml
```

### db2

`db2` - slave-хост базы данных. При удалении хоста выполняем повторную инициализацию

```bash
vagrant up db2
ansible-playbook -i ansible/hosts ansible/database-slave-reinit.yaml -e target=db2 -e master=db1 -e master_ip=10.10.1.131
```


## Полезные команды

Создание резервной копии статических файлов

```bash
ansible-playbook -i ansible/hosts ansible/nfs-create-backup.yaml
```

Восстановление статических файлов из резервной копии

```bash
ansible-playbook -i ansible/hosts ansible/nfs-recover-latest.yaml
```

Создание резервной копии БД
```bash
ansible-playbook -i ansible/hosts ansible/database-create-backup.yaml -e master=db1
```

Восстановление из резервной копии
```bash
ansible-playbook -i ansible/hosts ansible/database-recover-latest.yaml -e master=db1 -e master_ip=10.10.1.131 -e slave=db2
```

Переключение приложения на другой сервер БД
```bash
ansible-playbook -i ansible/hosts ansible/switch-app-on-another-master.yaml -e master_ip=10.10.1.131
```
