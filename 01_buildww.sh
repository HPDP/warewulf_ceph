#!/bin/bash

yum group install 'Development tools' 
yum install wireshark tcpdump perl-DBD-MySQL mariadb nfs-utils ntp perl-Term-ReadLine-Gnu tftp tftp-server pigz 

# Build Warewulf from SVN

WW_DIR=/opt/Warewulf-SVN
SOFTWARE_DIR=/root/install
BUILD_DIR=$SOFTWARE_DIR/rpmbuild
RPM_DIR=$SOFTWARE_DIR/Warewulf

function build_it { cd $1 && ./autogen.sh && make dist-gzip && make distcheck && cp -fa warewulf-*.tar.gz $2/SOURCES/ && rpmbuild -bb ./*.spec; }

cd /usr/include
h2ph -al * sys/*

mkdir -p $WW_DIR $RPM_DIR $BUILD_DIR/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

cd $WW_DIR
svn co https://warewulf.lbl.gov/svn/trunk/ ./

build_it $WW_DIR/common $BUILD_DIR
if [ ! -e $BUILD_DIR/RPMS/noarch/warewulf-common-*.el7.centos.noarch.rpm ]; then
        echo "ERROR: problem building 'common' package"
        exit 1
fi
rm -f $RPM_DIR/*.rpm
cp -p $BUILD_DIR/RPMS/noarch/warewulf-common-*.el7.centos.noarch.rpm $RPM_DIR/
yum install -y $RPM_DIR/warewulf-common-*.el7.centos.noarch.rpm

build_it $WW_DIR/provision $BUILD_DIR
cp -p $BUILD_DIR/RPMS/x86_64/warewulf-provision-*.el7.centos.x86_64.rpm $RPM_DIR/
cp -p $BUILD_DIR/RPMS/x86_64/warewulf-provision-server-*.el7.centos.x86_64.rpm $RPM_DIR/

build_it $WW_DIR/cluster $BUILD_DIR
cp -p $BUILD_DIR/RPMS/x86_64/warewulf-cluster-*.el7.centos.x86_64.rpm $RPM_DIR/

build_it $WW_DIR/vnfs $BUILD_DIR
cp -p $BUILD_DIR/RPMS/noarch/warewulf-vnfs-*.el7.centos.noarch.rpm $RPM_DIR/

# Build not working yet on el7
#build_it $WW_DIR/ipmi $BUILD_DIR
#cp -p $BUILD_DIR/RPMS/[?]/warewulf-vnfs-*.el7.centos.[?].rpm $RPM_DIR/

# For getting mod_perl, we temporarily use EPEL:
yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
yum install -y $RPM_DIR/warewulf-*-*.el7.centos.*.rpm
# ...and remove EPEL again, because it slows down 'yum update' so much:
yum remove -y epel-release

cd $WW_DIR/common
echo "===== SELF TEST ====="
make test

echo "=> If the test 'PASS'ed, you may now run the 'wwinit ALL' script."


