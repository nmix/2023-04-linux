# 06. NFS, FUSE

Цель: развернуть сервис NFS и подключить к нему клиента;


## Script

```bash
scriptreplay --timing=timing.log --divisor=5 script.log
```

## Tutorial

Создаем внутренню сеть в VirtualBox:

1) Файл -> Инструменты -> Meнеджер сетей -> вкладка "Сети NAT"

2) Создать -> Имя "net1", IPv4 префикс "192.168.50.0/24" -> Применить


Запускаем виртуальные машины

```bash
vagrant up
vagrant status
# Current machine states:
#
# nfss                      running (virtualbox)
# nfsc                      running (virtualbox)
```
