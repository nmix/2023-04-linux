# 22. Пользователь и группы. Авторизация и аутентификация PAM.

## Задание

Запретить всем пользователям, кроме группы admin, логин в выходные (суббота и воскресенье), без учета праздников

## Script

```bash
scriptreplay --timing=timing.log --divisor=5 script.log
```

## Tutorial

1. Необходимо изменить ip-адрес в Vagrantfile под свою виртуалку.

1. После `sudo -i` в последующих командах вводить `sudo` не требуется.


```bash
useradd otusadm && useradd otus
echo "Otus2022!" | passwd --stdin otusadm && echo "Otus2022!" | passwd --stdin otus

groupadd -f admin


usermod otusadm -a -G admin && usermod root -a -G admin && usermod vagrant -a -G admin
```

Отключаемся от ВМ и пробуем подключиться новыми пользователями (пароль *Otus2022!*).
Чтобы не мучиться с *known_hosts* в команду ssh добавляем пару опций:

```bash
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no otus@192.168.59.10
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no otusadm@192.168.59.10
```
Подключение проходит успешно.


Добавляем PAM аутентификацию:
```bash
vagrant ssh
sudo -i

cat /etc/group | grep admin
vim /usr/local/bin/login.sh

# --- копируем скрипт...

# --- назначаем права запуска
chmod +x /usr/local/bin/login.sh
```

Корректируем PAM файл и в отличии от методички (потому что не работает)
добавляем однту строку в конец файла.

```
# /etc/pam.d/sshd
# ...
auth required pam_exec.so /usr/local/bin/login.sh
```
Перезапускаем сервис
```bash
systemctl restart sshd
```

Отключаемся от ВМ и повторно пробуем подключиться пользователями *otus* и *otusadm*.

Для *otus* доступ отбивается после ввода пароля
```bash
otus@192.168.59.10's password: 
Permission denied, please try again.
otus@192.168.59.10's password: 
Permission denied, please try again.
otus@192.168.59.10's password:
```

Пользователь *otusadm* заходит без проблем.
