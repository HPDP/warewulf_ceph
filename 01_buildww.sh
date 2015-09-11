#!/bin/bash

# Build Warewulf from SVN
BUILD_DIR=~/rpmbuild
WW_DIR=~/warewulf/trunk
RPM_DIR=~/rpmbuild/RPMS/noarch
function build_it { cd $1 && ./autogen.sh && make dist-gzip && make distcheck && cp -fa warewulf-*.tar.gz $2/SOURCES/ && rpmbuild -bb ./*.spec; }

cd /usr/include
h2ph -al * sys/*

mkdir -p $BUILD_DIR/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

cd ~/
mkdir ~/warewulf
svn co https://warewulf.lbl.gov/svn/trunk/ ~/warewulf

build_it $WW_DIR/common $BUILD_DIR
yum install -y $RPM_DIR/warewulf-common-*.el7.centos.noarch.rpm

build_it $WW_DIR/provision $BUILD_DIR

build_it $WW_DIR/cluster $BUILD_DIR

build_it $WW_DIR/vnfs $BUILD_DIR

# Build not working yet on el7
#build_it $WW_DIR/ipmi $BUILD_DIR

yum install -y $RPM_DIR/warewulf-*-*.el7.centos.*.rpm


