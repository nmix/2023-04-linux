# 41. Динамический веб

## Задание

[Методичка](https://docs.google.com/document/d/1Q5Hqwq8dqsdRSDWA_bQKc1GsCx4wxi1c/edit)

Цель домашнего задания:

Получить практические навыки в настройке инфраструктуры с помощью манифестов и конфигураций.
Отточить навыки использования ansible/vagrant/docker.

Варианты стенда:
* nginx + php-fpm (laravel/wordpress) + python (flask/django) + js(react/angular);
* nginx + java (tomcat/jetty/netty) + go + ruby;
* можно свои комбинации.

Реализации на выбор:
* на хостовой системе через конфиги в /etc;
* деплой через docker-compose.

## Script

```bash
scriptreplay --timing=timing.log --divisor=5 script.log
```

## Практическая часть

Стенд построен на базе решения [microservices-demo](https://github.com/GoogleCloudPlatform/microservices-demo/tree/main).

На ВМ *worker* запущены сервисы: *frontend* (Go), *cartservice* (C#), *productcatalogservice* (Go), *currencyservice* (Node.js).
Это минимальный набор сервисов для отображения стартовой страницы.

![Стартовая страница Boutique.Online](./homepage.png)

Сервисы запущены через docker.

На ВМ *edge* запущен nginx, который проксирует запросы на ВМ *worker*. Nginx запущен нативно.

```bash
# --- добавляем доменные имена в /etc/hosts хоста
sudo vim /etc/hosts
# ...
192.168.56.10 boutique.local
192.168.56.11 otus.local

# --- запускаем вагрант 
vagrant up

# --- получаем стартовую страницу
curl boutique.local
```
