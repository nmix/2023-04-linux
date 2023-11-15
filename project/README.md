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
