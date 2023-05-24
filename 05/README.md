# 05. ZFS

## Задание

### 1. Определить алгоритм с наилучшим сжатием
Определить какие алгоритмы сжатия поддерживает zfs (gzip, zle, lzjb, lz4);
Создать 4 файловых системы на каждой применить свой алгоритм сжатия;
Для сжатия использовать либо текстовый файл, либо группу файлов:

### 2. Определить настройки пула
С помощью команды zfs import собрать pool ZFS;
Командами zfs определить настройки:
- размер хранилища;
- тип pool;
- значение recordsize;
- какое сжатие используется;
- какая контрольная сумма используется.

### 3. Работа со снапшотами
- скопировать файл из удаленной директории.   https://drive.google.com/file/d/1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG/view?usp=sharing 
- восстановить файл локально. zfs receive
- найти зашифрованное сообщение в файле secret_message

## Script

```bash
scriptreplay --timing=timing.log --divisor=5 script.log
```

## Tutorial

[Методическое пособие](https://docs.google.com/document/d/1xursgUsGDVTLh4B_r0XGw_flPzd5lSJ0nfMFL-HQmFs/edit?usp=share_link) оформлено очень хорошо, делаем по нему и всё работает.
