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
echo turnning on hybridpath in /etc/warewulf/vnfs.conf ...
sed -i '/# hybridpath /s/^#//g'  /etc/warewulf/vnfs.conf

wwinit ALL

