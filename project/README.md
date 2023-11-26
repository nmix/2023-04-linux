# Проектная работа

Наименование проектой работы - *Развертывание Django CMS с помощью Vagrant и Ansible*

## Схема развертывания

> TODO

## План восстановления

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


## Полезные команды

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
