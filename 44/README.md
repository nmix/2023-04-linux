# 44. Postgres: Backup + Репликация 

## Задание

Цели занятия:
* делать резервные копии;
* останавливаться базу в случае сбоя;
* настраивать репликами.

Краткое содержание:
* создание резервных копий с помощью Barman;
* настройка потоковой репликации Master-Slave;

[Методичка](https://docs.google.com/document/d/1EU_KF3x9e2f75sNL4sghDIxib9eMfqex/edit)

## Script

```bash
scriptreplay --timing=timing.log --divisor=5 script.log
```

## Практическая часть

Имя пользователя для реплиации *replicator*, не *replication*. Необходимо скорректировать pg_hba и команду `pg_basebackup`.
