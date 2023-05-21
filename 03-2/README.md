# 03. Файловые системы и LVM

На имеющемся образе (centos/7 1804.2)
https://gitlab.com/otus_linux/stands-03-lvm
/dev/mapper/VolGroup00-LogVol00 38G 738M 37G 2% /

* уменьшить том под / до 8G
* выделить том под /home
* выделить том под /var (/var - сделать в mirror)
* для /home - сделать том для снэпшотов
* прописать монтирование в fstab (попробовать с разными опциями и разными файловыми системами на выбор)
* Работа со снапшотами:
* сгенерировать файлы в /home/
* снять снэпшот
* удалить часть файлов
* восстановиться со снэпшота
(залоггировать работу можно утилитой script, скриншотами и т.п.)

## Script

```bash
scriptreplay --timing=timing.log --divisor=5 script.log
```

## Tutorial

### Уменьшаем том под / до 8G
```bash
vagrant ssh
sudo -i
lsblk
# --- подготавливаем временный том для корневого раздела
pvcreate /dev/sdb
vgcreate vg_root /dev/sdb
lvcreate -n lv_root -l +100%FREE /dev/vg_root
# --- создаем файловую систему и монтируем его, чтобы перенести туда данные
mkfs.xfs /dev/vg_root/lv_root
mount /dev/vg_root/lv_root /mnt
# --- копируем все данные из корневого раздела в /mnt
xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt 
# --- магия ...
#    "Сымитируем текущий root -> сделаем в него chroot и обновим grub"
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt/
grub2-mkconfig -o /boot/grub2/grub.cfg
# --- еще магия
cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g;  s/.img//g"` --force; done
# ---
export TERM=xterm
vim /boot/grub2/grub.cfg
# меняем rd.lvm.lv=VolGroup00/LogVol00 на rd.lvm.lv=vg_root/lv_root

# --- перезагрузка
```
```bash
vagrant ssh
sudo -i
lsblk

# --- уменьшаем размер старого логического тома с 40ГБ до 8ГБ (через удаление)
lvremove /dev/VolGroup00/LogVol00
lvcreate -n VolGroup00/LogVol00 -L 8G /dev/VolGroup00
# --- повторяем действия по переносу корневой системы (только без исправления grub)
mkfs.xfs /dev/VolGroup00/LogVol00
mount /dev/VolGroup00/LogVol00 /mnt
xfsdump -J - /dev/vg_root/lv_root | xfsrestore -J - /mnt
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt/
grub2-mkconfig -o /boot/grub2/grub.cfg
cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g;  s/.img//g"` --force; done
```

### Выделяем том под /var (/var - сделать в mirror)
```bash
# --- пока не выходим из chroot и не перезагруемся, переносим var
#     создаем зеркало на свободных дисках
pvcreate /dev/sdc /dev/sdd
vgcreate vg_var /dev/sdc /dev/sdd
lvcreate -L 950M -m1 -n lv_var vg_var

# --- Создаем на нем ФС и перемещаем туда /var:
mkfs.ext4 /dev/vg_var/lv_var
mount /dev/vg_var/lv_var /mnt
cp -aR /var/* /mnt/
# --- сохраняем содержимое старого var
mkdir /tmp/oldvar && mv /var/* /tmp/oldvar

# --- монтируем новый var в /var
umount /mnt
mount /dev/vg_var/lv_var /var

# --- правим fstab для автомонтирования /var
echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab

# --- перезагрузка

# --- удаляем временные тома
lvremove /dev/vg_root/lv_root
vgremove /dev/vg_root
pvremove /dev/sdb
```

### Выделяем том под /home
Делаем по принципу с /var
```bash
lsblk
lvcreate -n LogVol_Home -L 2G /dev/VolGroup00
mkfs.xfs /dev/VolGroup00/LogVol_Home
mount /dev/VolGroup00/LogVol_Home /mnt/
cp -aR /home/* /mnt/
rm -rf /home/*
umount /mnt
mount /dev/VolGroup00/LogVol_Home /home/
echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab
# --- перезагружаемся
lsblk
```

### для /home - сделать том для снэпшотов
```bash
vagrant ssh
# --- !!! обязательно выходим из домашней директории !!!
cd /tmp
sudo -i
# --- создаем произвольный файлы
touch /home/file{1..20}
# --- создаем snapshot
lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home
# --- удаляем часть файлов
rm -f /home/file{11..20}
ls -l /home


# --- восстанавливаем файлы
umount /home
lvconvert --merge /dev/VolGroup00/home_snap
mount /home
ls -l /home
```
