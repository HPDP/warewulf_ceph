#!/bin/bash

#using centos 7
hostnamectl set-hostname wulf.ceph --static

## disable selinux
sed -i 's+=enforcing+=disabled+g' /etc/selinux/config

## disable firewall
systemctl disable firewalld

## ntp
yum install -y ntp 
systemctl enable ntpd

## ceph repo, update all nodes
rpm -Uhv http://ceph.com/rpm-hammer/el7/noarch/ceph-release-1-1.el7.noarch.rpm

yum -y update 
yum -y install epel-release
yum -y install snappy leveldb gdisk python-argparse gperftools-libs attr
yum -y install ceph ceph-deploy --disablerepo=epel

chkconfig ceph on

## these are for warewulf
yum -y group install 'Development tools' 
yum -y install wireshark tcpdump perl-DBD-MySQL mariadb nfs-utils ntp perl-Term-ReadLine-Gnu tftp tftp-server pigz dhcp
yum -y install libselinux-devel libacl-devel libattr-devel pdsh

reboot

