#!/bin/bash

#using centos 7
## disable selinux
sed -i 's+=enforcing+=disabled+g' /etc/selinux/config

## disable firewall

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
yum -y install wireshark tcpdump perl-DBD-MySQL mariadb nfs-utils ntp perl-Term-ReadLine-Gnu tftp tftp-server pigz 
yum -y install libselinux-devel libacl-devel libattr-devel

# Build Warewulf from SVN
BUILD_DIR=/root/rpmbuild
WW_DIR=/root/warewulf
RPM_DIR=/root/rpmbuild/RPMS/
function build_it { cd $1 && ./autogen.sh && make dist-gzip && make distcheck && cp -fa warewulf-*.tar.gz $2/SOURCES/ && rpmbuild -bb ./*.spec; }

cd /usr/include
h2ph -al * sys/*

mkdir -p $BUILD_DIR/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

mkdir /root/warewulf
svn co https://warewulf.lbl.gov/svn/trunk/ /root/warewulf

build_it $WW_DIR/common $BUILD_DIR
yum install -y $RPM_DIR/noarch/warewulf-common-*.rpm

build_it $WW_DIR/provision $BUILD_DIR
yum install -y $RPM_DIR/x86_64/warewulf-provision-*.rpm

build_it $WW_DIR/cluster $BUILD_DIR
yum install -y $RPM_DIR/x86_64/warewulf-cluster-*.rpm

## remove debian.tmpl from Makefil* in vnfs/libexec/wwmkchroot
sed -i 's+debian.tmpl+ +g' $WW_DIR/vnfs/libexec/wwmkchroot/Makefil*
build_it $WW_DIR/vnfs $BUILD_DIR
yum install -y $RPM_DIR/noarch/warewulf-vnfs-*.rpm

# monitor
ln -s /usr/lib64/libjson.so.0 /usr/lib64/libjson.so 
ln -s /usr/lib64/libjson-c.so.2 /usr/lib64/libjson-c.so
ln -s /usr/lib64/libsqlite3.so.0 /usr/lib64/libsqlite3.so
yum -y install json-c-devel json-devel sqlite-devel
build_it $WW_DIR/monitor $BUILD_DIR
yum -y install $RPM_DIR/x86_64/warewulf-monitor*.rpm

#build_it $WW_DIR/ipmi $BUILD_DIR
#yum -y install $RPM_DIR/x86_64/warewulf-ipmi*.rpm




