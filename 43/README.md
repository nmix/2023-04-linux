# 43. MySQL: Backup + Репликация 

## Задание

[Методичка](https://docs.google.com/document/d/1d1U6Dr49lSimPJvbV6DYy45fMzMJT4jB43HSUdFlctA/edit)

В материалах приложены ссылки на вагрант для репликации и дамп базы bet.dmp
Базу развернуть на мастере и настроить так, чтобы реплицировались таблицы:
```
| bookmaker |
| competition |
| market |
| odds |
| outcome |
```

Настроить GTID репликацию

## Script

```bash
scriptreplay --timing=timing.log --divisor=5 script.log
```

## Практическая часть

Выявлено, что репликация не будет запускаться, если на *slave* создать
из дампа реплицируемую базу данных *bet*. В ошибке отображается 
"база данных уже существует".
