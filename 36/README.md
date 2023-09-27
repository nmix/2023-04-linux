# 36. Сетевые пакеты. VLAN'ы. LACP

## Задание

[Методичка](https://docs.google.com/document/d/1BO5cUT0u4ABzEOjogeHyCaNiYh76Bh73/edit)

в Office1 в тестовой подсети появляется сервера с доп интерфесами и адресами
в internal сети testLAN: 
- testClient1 - 10.10.10.254
- testClient2 - 10.10.10.254
- testServer1- 10.10.10.1 
- testServer2- 10.10.10.1

Равести вланами:
testClient1 <-> testServer1
testClient2 <-> testServer2

Между centralRouter и inetRouter "пробросить" 2 линка (общая inernal сеть) и объединить их в бонд, проверить работу c отключением интерфейсов

## Script

```bash
scriptreplay --timing=timing.log --divisor=5 script.log
```

## Практика

В случае, если используются отличные от методички образы системы, то необходимо
обращать особое внимание на именование интерфейсов в конфигурации: eth или enp.
