#!/bin/bash

# Build Warewulf from SVN
BUILD_DIR=/root/rpmbuild
WW_DIR=/root/warewulf
RPM_DIR=/root/rpmbuild/RPMS/
function build_it { cd $1 && ./autogen.sh && make dist-gzip && make distcheck && cp -fa warewulf-*.tar.gz $2/SOURCES/ && rpmbuild -bb ./*.spec; }

cd /usr/include
h2ph -al * sys/*

mkdir -p $BUILD_DIR/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

mkdir /root/warewulf
echo p | svn co https://warewulf.lbl.gov/svn/trunk/ /root/warewulf

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
yum -y install $RPM_DIR/x86_64/warewulf-monitor-0*.rpm
yum -y install $RPM_DIR/x86_64/warewulf-monitor-cl*.rpm

#build_it $WW_DIR/ipmi $BUILD_DIR
#yum -y install $RPM_DIR/x86_64/warewulf-ipmi*.rpm

rpm -qa | grep warewulf

## for monitor
chkconfig aggregator on
service aggregator start
sed -i 's+127.0.0.1+172.16.2.250+g' /etc/warewulf/monitor.conf
sleep 5

exit

