#!/bin/bash

## add ssh known host to compute nodes
for i in `grep eth0 /etc/hosts | awk '{print $1 "\n" $3}' ` ; do
  ssh-keyscan $i
done > /etc/ssh/ssh_known_hosts

cp /etc/ssh/ssh_known_hosts /var/chroots/centos-6-stateful/etc/ssh

## install nptd to comupte nodes to sync time with master
yum --tolerant --installroot /var/chroots/centos-6-stateful -y install ntp warewulf-monitor-legacy-wulfd

sed -i '/centos.pool.ntp.org/c\server 172.16.2.250' /var/chroots/centos-6-stateful/etc/ntp.conf

chroot /var/chroots/centos-6-stateful/ chkconfig ntpd on

sed -i '/WAREWULF_MASTER/c\WAREWULF_MASTER=172.16.2.250' /var/chroots/centos-6-stateful/etc/sysconfig/wulfd.conf

HOSTLIST=`grep eth0 /etc/hosts | awk '{print $3}' | paste -d, -s`
sed -i "/WAREWULFD_HOSTS/c\WAREWULFD_HOSTS=$HOSTLIST " /etc/sysconfig/wwproxy.conf

