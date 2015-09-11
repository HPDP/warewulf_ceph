#!/bin/bash

function buildit { cd $1 && ./autogen.sh && make dist-gzip && make distcheck && cp -fa warewulf-*.tar.gz ~/rpmbuild/SOURCES/ && rpmbuild -bb ./*.spec; cd $OLDPWD; } 

function svn-clean { svn st | grep '^?' | awk '{print $2}' | xargs rm -rf; } 

mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS} 

yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm 
yum -ygroup install 'Development tools' 
yum -y install wireshark tcpdump perl-DBD-MySQL mariadb nfs-utils ntp perl-Term-ReadLine-Gnu tftp tftp-server pigz 

svn co https://warewulf.lbl.gov/svn/ warewulf 
cd warewulf/trunk 

buildit common 
yum install ~/rpmbuild/RPMS/noarch/warewulf-common-3.6.1-0.*.el7.centos.noarch.rpm 

buildit provision 
yum install ~/rpmbuild/RPMS/x86_64/warewulf-provision-3.6.1-0.*.el7.centos.x86_64.rpm ~/rpmbuild/RPMS/x86_64/warewulf-provision-server-3.6.1-0.*.el7.centos.x86_64.rpm 

buildit cluster 
yum install ~/rpmbuild/RPMS/x86_64/warewulf-cluster-3.6.1-0.*.el7.centos.x86_64.rpm 

buildit vnfs 
yum install ~/rpmbuild/RPMS/noarch/warewulf-vnfs-3.6.1-0.*.el7.centos.noarch.rpm 

    # Build not working yet on el7 
    #buildit ipmi 

mkdir -p /var/chroots 