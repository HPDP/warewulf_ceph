#!/bin/bash

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
yum install -y $RPM_DIR/noarch/warewulf-common-*.el7.centos.noarch.rpm

build_it $WW_DIR/provision $BUILD_DIR
yum install -y $RPM_DIR/x86_64/warewulf-provision-*.el7.centos.noarch.rpm

build_it $WW_DIR/cluster $BUILD_DIR
yum install -y $RPM_DIR/x86_64/warewulf-cluster-*.el7.centos.noarch.rpm

build_it $WW_DIR/vnfs $BUILD_DIR
yum install -y $RPM_DIR/x86_64/warewulf-vnfs-*.el7.centos.noarch.rpm

# Build not working yet on el7
#build_it $WW_DIR/ipmi $BUILD_DIR




