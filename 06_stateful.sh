#!/bin/bash

yum --tolerant --installroot /var/chroots/centos-7 -y install kernel grub

## so the nodes have root passwd set
cp -f /etc/passwd /var/chroots/centos-7/etc
cp -f /etc/group /var/chroots/centos-7/etc
cp -f /etc/shadow /var/chroots/centos-7/etc

wwvnfs -y --chroot /var/chroots/centos-7

./ww-configure-stateful.sh c[001-004] 500 sda

## this will statefully provision the nodes
./reboot_all