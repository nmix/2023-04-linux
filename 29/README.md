# 29. Фильтрация трафика - firewalld, iptables 

## Задание

1. Реализовать knocking port: centralRouter может попасть на ssh inetRouter через knock скрипт 
([пример](https://wiki.archlinux.org/title/Port_knocking)).
2. Добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост.
запустить nginx на centralServer.
3. Пробросить 80й порт на inetRouter2 8080.
4. Дефолт в инет оставить через inetRouter.

## Script

```bash
scriptreplay --timing=timing.log --divisor=5 script.log
```

## Практика

```bash
vagrant up

#
# --- knock-сервер
#

vagrant ssh centralRouter
# --- соединение не устанавливается
ssh 192.168.255.1
# --- выполняем опрос портов в заданной последовательности (для открытия порта)
./knock.sh 192.168.255.1 7000 8000 9000
# --- соединение устанавливается
ssh 192.168.255.1
# --- выполняем опрос портов в заданной последовательности (для закрытия порта)
./knock.sh 192.168.255.1 9000 8000 7000
# --- соединение не устанавливается
ssh 192.168.255.1


#
# --- проброс портов (nginx поднят на centralServer)
#
vagrant ssh inetRouter2
curl localhost:8080
# --- получаем html-код страницы по умолчанию
```
