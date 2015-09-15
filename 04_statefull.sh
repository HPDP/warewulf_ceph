#!/bin/bash

wwmkchroot centos-7 /var/chroots/centos-7
yum -y --installroot=/var/chroots/centos-7 install kernel grub

## so the nodes have root passwd set
cp -f /etc/passwd /var/chroots/centos-7/etc
cp -f /etc/group /var/chroots/centos-7/etc
cp -f /etc/shadow /var/chroots/centos-7/etc

wwvnfs --chroot /var/chroots/centos-7
