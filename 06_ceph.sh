#!/bin/bash

## install ceph to vnfs

yum --tolerant --installroot /var/chroots/centos-7 -y install snappy leveldb gdisk python-argparse gperftools-libs ntp ntpdate ntp-doc 
yum --tolerant --installroot /var/chroots/centos-7 -y install ceph --disablerepo=epel

chroot /var/chroots/centos-7/ systemctl disable firewalld
chroot /var/chroots/centos-7/ chkconfig ceph on