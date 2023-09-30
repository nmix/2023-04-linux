# 37. LDAP. Централизованная авторизация и аутентификация

## Задание

[Методичка](https://docs.google.com/document/d/1HoZBcvitZ4A9t-y6sbLEbzKmf4CWvb39/edit)

Цель домашнего задания:
Научиться настраивать LDAP-сервер и подключать к нему LDAP-клиентов

Описание домашнего задания:
1) Установить FreeIPA
2) Написать Ansible-playbook для конфигурации клиента


## Script

```bash
scriptreplay --timing=timing.log --divisor=5 script.log
```

## Практическая часть

Первым шагом поднимаем виртуальную машину сервера ipa:

```bash
vagrant up ipa.otus.lan
```

Подключаемся к серверу и выполняем конфигурацию согласно методичке:

```bash
vagrant ssh ipa.otus.lan
sudo -i
# ...
```

Сразу добвыляем нового пользователя

```bash
ipa user-add otus-user --first=Otus --last=User --password
```


Далее поднимаем клиентские виртуальные машины. Конфигурацию выполняется
автоматически через ansible-сценарий:

> Подразумевается, что пароль администратора ipa - `supersecret`. Если при
установке указан другой пароль, то его необходимо указать в опции `-w`
в ansible-сценарии на шаге `add host to ipa-server`.

```bash
vagrant up
```

Подключаемся к кленту и добавляем хосты

```bash
vagrant ssh client1.otus.lan
sudo -i
kinit otus-user
# ...
```
