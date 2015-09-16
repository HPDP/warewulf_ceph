#!/bin/bash

## add ssh known host to compute nodes
for i in `grep eth0 /etc/hosts | awk '{print $1 "\n" $3}' ` ; do
  ssh-keyscan $i
done > /etc/ssh/ssh_known_hosts

cp /etc/ssh/ssh_known_hosts /var/chroots/centos-7/etc/ssh

## install nptd to comupte nodes to sync time with master
yum --tolerant --installroot /var/chroots/centos-7 -y install ntp
yum --tolerant --installroot /var/chroots/centos-7 -y install ~/rpmbuild/RPMS/x86_64/warewulf-monitor*.rpm

sed -i '/.pool.ntp.org/c\server 172.16.2.250' /var/chroots/centos-7/etc/ntp.conf

chroot /var/chroots/centos-7/ systemctl enable ntpd

sed -i '/WAREWULF_MASTER/c\WAREWULF_MASTER=172.16.2.250' /var/chroots/centos-7/etc/sysconfig/wulfd.conf

HOSTLIST=`grep eth0 /etc/hosts | awk '{print $3}' | paste -d, -s`
sed -i "/WAREWULFD_HOSTS/c\WAREWULFD_HOSTS=$HOSTLIST " /etc/sysconfig/wwproxy.conf

