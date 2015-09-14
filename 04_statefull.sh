#!/bin/bash

wwmkchroot centos-7 /var/chroots/centos-7
yum -y --installroot=/var/chroots/centos-7 install kernel grub
wwvnfs --chroot /var/chroots/centos-7
