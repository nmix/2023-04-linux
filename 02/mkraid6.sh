#!/usr/bin/env bash

for i in $(seq 1 5); do umount /dev/md0p$i; done

echo "--------- CREATE RAID6 ------------"

mdadm --zero-superblock --force /dev/sd{a,b,c,d,e}

mdadm --create --verbose /dev/md0 -l 6 -n 5 /dev/sd{a,b,c,d,e}

cat /proc/mdstat

mdadm -D /dev/md0

echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
cat /etc/mdadm/mdadm.conf

echo "--------- CREATE GPT ------------"

parted -s /dev/md0 mklabel gpt
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%

for i in $(seq 1 5); do mkfs.ext4 -F /dev/md0p$i; done

mkdir -p /raid/part{1,2,3,4,5}

for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done

tree -L 2 /raid
