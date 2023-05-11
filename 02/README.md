# 02. Дисковая подсистема

В качестве базового используем предложенный Vagrantfile https://github.com/erlong15/otus-linux , который доработаем в части:
* замена образа на Ubuntu
* замена SATA на Virtual SCSI (система не загружается)
* удаляем диски при удалении ВМ (если этого не сделать, заново создать диски не получится)
* provision ВМ скорректирован: использован apt-get и 

```bash
vagrant up
vagrant ssh
```

### Собираем RAID6

```bash
# --- **посмотрим, какие блочные устройства у нас есть**
sudo lshw -short | grep disk                                                                                                                                             
# /0/100/f/0/0.1.0   /dev/sda   disk           262MB HARDDISK
# /0/100/f/0/0.2.0   /dev/sdb   disk           262MB HARDDISK
# /0/100/f/0/0.3.0   /dev/sdc   disk           262MB HARDDISK
# /0/100/f/0/0.4.0   /dev/sdd   disk           262MB HARDDISK
# /0/100/f/0/0.5.0   /dev/sde   disk           262MB HARDDISK
# /0/100/14/0.0.0    /dev/sdf   disk           42GB HARDDISK
# /0/100/14/0.1.0    /dev/sdg   disk           10MB HARDDISK

# --- **Занулим на всякий случай суперблоки**
#     Если выдает ошибку типа mdadm: Unrecognised md component device - /dev/sda,
#     то ничего страшного идем дальше.
#     Подробно здесь - https://admins24.com/ispolzovanie-utility-mdadm-dlya-raboty-s-raid-v-linux/
sudo mdadm --zero-superblock --force /dev/sd{a,b,c,d,e}
# mdadm: Unrecognised md component device - /dev/sda
# ...

# --- создаем RAID 6 из 5ти устройств
sudo mdadm --create --verbose /dev/md0 -l 6 -n 5 /dev/sd{a,b,c,d,e}
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: size set to 253952K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started

# --- **Проверим, что RAID собрался нормально:**
cat /proc/mdstat
# Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
# md0 : active raid6 sde[4] sdd[3] sdc[2] sdb[1] sda[0]
#       761856 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]

sudo mdadm -D /dev/md0
# /dev/md0:
#            Version : 1.2
#      Creation Time : Thu May 11 15:59:54 2023
#         Raid Level : raid6
# ...

# --- создаем файл mdadm.conf
sudo -i
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
cat /etc/mdadm/mdadm.conf
# DEVICE partitions
# ARRAY /dev/md0 level=raid6 num-devices=5 metadata=1.2 name=otuslinux:0 UUID=469d1f82:c0a7a068:811f3b3a:fc72f32f
exit

# --- "ломаем" RAID
#     указываем устройство как неисправное
sudo mdadm /dev/md0 --fail /dev/sde
# mdadm: set /dev/sde faulty in /dev/md0

cat /proc/mdstat
# Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
# md0 : active raid6 sde[4](F) sdd[3] sdc[2] sdb[1] sda[0]
#       761856 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/4] [UUUU_]

sudo mdadm -D /dev/md0
# ...
#     Number   Major   Minor   RaidDevice State
#        0       8        0        0      active sync   /dev/sda
#        1       8       16        1      active sync   /dev/sdb
#        2       8       32        2      active sync   /dev/sdc
#        3       8       48        3      active sync   /dev/sdd
#        -       0        0        4      removed                  <---------------------------
# 
#        4       8       64        -      faulty   /dev/sde        <---------------------------

# --- **Удалим “сломанный” диск из массива**
sudo mdadm /dev/md0 --remove /dev/sde
# mdadm: hot removed /dev/sde from /dev/md0

# --- как будто заменили диск, теперь добавляем его в RAID
sudo mdadm /dev/md0 --add /dev/sde
sudo mdadm -D /dev/md0
# ...
# 5       8       64        4      spare rebuilding   /dev/sde
sudo mdadm -D /dev/md0
# ...
# 5       8       64        4      active sync   /dev/sde
```

### Создаем GPT раздел

```bash
# --- создаем GPT раздел на RAID
sudo parted -s /dev/md0 mklabel gpt

# --- создаем партиции
sudo parted /dev/md0 mkpart primary ext4 0% 20%
# Information: You may need to update /etc/fstab.
sudo parted /dev/md0 mkpart primary ext4 20% 40%
# Information: You may need to update /etc/fstab.
sudo parted /dev/md0 mkpart primary ext4 40% 60%
# Information: You may need to update /etc/fstab.
sudo parted /dev/md0 mkpart primary ext4 60% 80%
# Information: You may need to update /etc/fstab.
sudo parted /dev/md0 mkpart primary ext4 80% 100%
# Information: You may need to update /etc/fstab.

# --- создаем ФС на партициях
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done
# mke2fs 1.47.0 (5-Feb-2023)                                                                     
# Creating filesystem with 37632 4k blocks and 37632 inodes
# Filesystem UUID: 75171518-46a6-494b-9d82-ed05a3149774
# Superblock backups stored on blocks: 
#         32768
# ...

# --- монтируем в каталоги
sudo mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do sudo mount /dev/md0p$i /raid/part$i; done

# --- смотрим, что получилось
tree -L 2 /raid
# /raid
# ├── part1
# │   └── lost+found
# ├── part2
# │   └── lost+found
# ├── part3
# │   └── lost+found
# ├── part4
# │   └── lost+found
# └── part5
#     └── lost+found

# --- размонтирование разделов
for i in $(seq 1 5); do sudo umount /dev/md0p$i; done
```

### Скрипт

Выполняем все действия одним скриптом
```bash
vagrant ssh
sudo ./mkraid6.sh
```
