#!/bin/bash

#using centos 7
hostnamectl set-hostname ceph-wulf.myceph --static

## disable selinux
sed -i 's+=enforcing+=disabled+g' /etc/selinux/config

## disable firewall
systemctl disable firewalld

## ntp
yum install -y ntp ntpdate ntp-doc 
systemctl enable ntpd

useradd ceph
echo bwv988 | passwd ceph --stdin
echo "ceph ALL = (root) NOPASSWD:ALL" | tee /etc/sudoers.d/ceph
chmod 0440 /etc/sudoers.d/ceph
sed -i s'/Defaults    requiretty/Defaults:ceph    !requiretty'/g /etc/sudoers

## ceph repo, update all nodes
rpm -Uhv http://ceph.com/rpm-hammer/el7/noarch/ceph-release-1-0.el7.noarch.rpm

yum -y update 
yum -y install epel-release
yum -y install snappy leveldb gdisk python-argparse gperftools-libs
yum -y install ceph --disablerepo=epel

chkconfig ceph on

yum -y group install 'Development tools' 
yum -y install wireshark tcpdump perl-DBD-MySQL mariadb nfs-utils ntp perl-Term-ReadLine-Gnu tftp tftp-server pigz dhcp
yum -y install libselinux-devel libacl-devel libattr-devel

service enable dhcpd rpcbind nfs-server

reboot

