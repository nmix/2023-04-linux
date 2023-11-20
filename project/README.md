# Проектная работа

Наименование проектой работы - *Развертывание Django CMS с помощью Vagrant и Ansible*

## Схема развертывания

> TODO

## План восстановления

### db1

Если удален хост мастер базы данных

```bash
# --- возобновляем работу приложения
ansible-playbook -i ansible/hosts ansible/promote-database.yaml -e target=db2
ansible-playbook -i ansible/hosts ansible/switch-on-another-master.yaml -e db_ip=10.10.1.132
# --- готовим новую реплику
vagrant up db1
ansible-playbook -u ansible/hosts ansible/database-slave-reinit.yaml -e target=db1
ansible-playbook -u ansible/hosts ansible/switch-barman-on-another-master.yaml -e master=db2
```

## Полезные команды

Создание резервной копии БД
```bash
# barman backup db1
# barman list-backups db1
ansible-playbook -u ansible/hosts ansible/create-database-backup.yaml -e master=db1
```
