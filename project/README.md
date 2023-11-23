# Проектная работа

Наименование проектой работы - *Развертывание Django CMS с помощью Vagrant и Ansible*

## Схема развертывания

> TODO

## План восстановления

### db1

`db1` - мастер базы данных

```bash
# --- возобновляем работу приложения
ansible-playbook -i ansible/hosts ansible/promote-database.yaml -e target=db2
ansible-playbook -i ansible/hosts ansible/switch-app-on-another-master.yaml -e master_ip=10.10.1.132
# --- готовим новую реплику
vagrant up db1
ansible-playbook -i ansible/hosts ansible/database-slave-reinit.yaml -e target=db1 -e master_ip=10.10.1.132
ansible-playbook -i ansible/hosts ansible/switch-barman-on-another-slave.yaml
```

## Полезные команды

Создание резервной копии БД
```bash
ansible-playbook -i ansible/hosts ansible/create-database-backup.yaml -e db=db1
```
