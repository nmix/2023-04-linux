# Проектная работа

Наименование проектой работы - *Развертывание Django CMS с помощью Vagrant и Ansible*

## Схема развертывания

> TODO

## План восстановления

> TODO

## Полезные команды

Запуск одельного плейбука (не через Vagrant)
```bash
ansible-playbook -i ansible/hosts ansible/playbook-name.yaml
```

Создание резервной копии БД
```bash
barman backup db1
barman list-backups db1
```

Переводим Slave в Master
```bash
# --- on master
systemctl stop postgresql-14
# --- on slave
/usr/pgsql-14/bin/pg_ctl promote -D /var/lib/pgsql/14/data
```
