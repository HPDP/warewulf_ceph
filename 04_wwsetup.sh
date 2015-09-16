#!/bin/bash

mysqladmin -u root password 'password'

## warewulf mysql set up
sed -i '/database user/c\database user = root' /etc/warewulf/database.conf
sed -i '/database password/c\database password = password'  /etc/warewulf/database.conf
sed -i '/database password/c\database password = password' /etc/warewulf/database-root.conf

cat > ~/.my.cnf <<EOF
[client]
user = root
password = password
EOF

chmod 0600 ~/.my.cnf

## edit /etc/warewulf/provision.conf, change eth1 to enp0s8, for centos-7
## otherwise nfs-server and dhcpd fail
sed -i '/network device/c\network device = enp0s8' /etc/warewulf/provision.conf

## edit /etc/warewulf/vnfs.conf, uncomment hybridpath= ...
##echo turnning on hybridpath in /etc/warewulf/vnfs.conf ...
##sed -i '/# hybridpath /s/^#//g'  /etc/warewulf/vnfs.conf

wwinit ALL
wwmkchroot centos-7 /var/chroots/centos-7
wwvnfs --chroot /var/chroots/centos-7

echo @
echo @
echo @
echo "warewulf scanning and adding nodes"
echo "please set compute nodes to PXE boot and bring up them one by one in order"
echo "when all nodes are recorded stop(ctl-c) this script"
echo @
echo @
echo @
sleep 3
wwnodescan --netdev=enps03 --ipaddr=172.16.0.1 --netmask=255.255.0.0 --vnfs=centos-7 --bootstrap=`uname -r` --groups=compute c[001-999]

