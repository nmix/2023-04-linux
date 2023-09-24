# 35. DNS-настройка и обслуживание

## Задание

[Методичка](https://docs.google.com/document/d/13kjusaFEzv6Ip_9soeDj2Ry-6WK8IDX7/edit)

1. взять стенд https://github.com/erlong15/vagrant-bind 
 * добавить еще один сервер client2
 * завести в зоне dns.lab имена:
 * web1 - смотрит на клиент1
 * web2  смотрит на клиент2
 * завести еще одну зону newdns.lab
 * завести в ней запись
 * www - смотрит на обоих клиентов

2. настроить split-dns
 * клиент1 - видит обе зоны, но в зоне dns.lab только web1
 * клиент2 видит только dns.lab

## Script

```bash
scriptreplay --timing=timing.log --divisor=5 script.log
```

## Практика

Для задания 1 выполняется плейбук из директории provisioning.

Для задания 2 выполняется плейбук из директории provisioning2.
