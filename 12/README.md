# 12. Управление процессами

## Задание

Задания на выбор:

* написать свою реализацию ps ax используя анализ /proc
Результат ДЗ - рабочий скрипт который можно запустить

* написать свою реализацию lsof
Результат ДЗ - рабочий скрипт который можно запустить

* дописать обработчики сигналов в прилагаемом скрипте, оттестировать, приложить сам скрипт, инструкции по использованию
Результат ДЗ - рабочий скрипт который можно запустить + инструкция по использованию и лог консоли

* реализовать 2 конкурирующих процесса по IO. пробовать запустить с разными ionice
Результат ДЗ - скрипт запускающий 2 процесса с разными ionice, замеряющий время выполнения и лог консоли

* реализовать 2 конкурирующих процесса по CPU. пробовать запустить с разными nice
Результат ДЗ - скрипт запускающий 2 процесса с разными nice и замеряющий время выполнения и лог консоли

## Алгоритм работы

Предварительно получаем массив идентификаторов процессов.
Далее для каждого идентификатора (PID) получаем значения:

* TTY - /proc/$PID/fd/0
* STAT - /proc/$PID/status
* TIME - /proc/$PID/stat
* COMMDN - /proc/$PID/cmdline или /proc/$PID/status

## Выполнение

Выбираем первое задание: написать свою реализацию ps ax используя анализ /proc

```bash
./psax.sh

PID     TTY     STAT    TIME    COMMAND
1       ?       S       07:17   [systemd]
2       ?       S       00:04   [kthreadd]
3       ?       I       00:00   [rcu_gp]
4       ?       I       00:00   [rcu_par_gp]
5       ?       I       00:00   [slub_flushwq]
6       ?       I       00:00   [netns]
# ...
3638    ?       S       00:05   /usr/libexec/goa-daemon
3646    ?       S       00:09   /usr/libexec/goa-identity-service
3655    tty2    S       00:00   /usr/libexec/gdm-x-session--run-scriptenv GNOME_SHELL_SESSION_MODE=ubuntu /usr/bin/gnome-session
# ...
250270  pts/5   S       00:25   bash
255705  pts/5   S       00:00   tmux
255706  pts/6   S       00:22   -bash
256052  pts/6   S       32:08   vim
# ...
```
