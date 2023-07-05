# 15. Автоматизация администрирования. Ansible-1

## Задание

Подготовить стенд на Vagrant как минимум с одним сервером. На этом сервере используя Ansible необходимо развернуть nginx со следующими условиями:
* необходимо использовать модуль yum/apt;
* конфигурационные файлы должны быть взяты из шаблона jinja2 с перемененными;
* после установки nginx должен быть в режиме enabled в systemd;
* должен быть использован notify для старта nginx после установки;
* сайт должен слушать на нестандартном порту - 8080, для этого использовать переменные в Ansible.

## Методичка

https://docs.google.com/document/d/1q2h7ZM_yHDfwxSpzArO57j4Cm7daaWzmzqtuEGIcy9A/edit?pli=1

## Script

```bash
scriptreplay --timing=timing.log --divisor=5 script.log
```

## Notes

В плейбук были добавлены два таска: (1) явный запуск сервиса nginx (2) остановка сервиса firewalld