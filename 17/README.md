# 17.  SELinux

## Задание

Запустить nginx на нестандартном порту 3-мя разными способами:
 * переключатели setsebool;
 * добавление нестандартного порта в имеющийся тип;
 * формирование и установка модуля SELinux.

Обеспечить работоспособность приложения при включенном selinux
 * развернуть приложенный стенд https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems;
 * выяснить причину неработоспособности механизма обновления зоны (см. README);
 * предложить решение (или решения) для данной проблемы;
 * выбрать одно из решений для реализации, предварительно обосновав выбор;
 * реализовать выбранное решение и продемонстрировать его работоспособность.

Методичка - https://docs.google.com/document/d/1QwyccIn8jijBKdaoNR4DCtTULEqb5MKK/edit?usp=share_link&ouid=104106368295333385634&rtpof=true&sd=true


## Script

```bash
# --- Запустить nginx на нестандартном порту 3-мя разными способами
scriptreplay --timing=timing1.log --divisor=5 script1.log
# --- Обеспечить работоспособность приложения при включенном selinux
scriptreplay --timing=timing2.log --divisor=5 script2.log
```

## Notes

Команда `audit2why` отсутствует в системе. Команда установки
```bash
yum install policycoreutils-python
```
