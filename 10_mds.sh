#!/bin/bash

## MDS is only needed if you want to use CephFS
## MDS nodes need a lot of RAM

cat >> /home/ceph/ceph/ceph.conf <<EOF

[mds]
mds data = /var/lib/ceph/mds/mds.0
keyring = /var/lib/ceph/mds/mds.0/mds.0.keyring

[mds.0]
host = c001

EOF

pdsh cp -f /home/ceph/ceph/ceph.conf /etc/ceph/ceph.conf
cp -f /home/ceph/ceph/ceph.conf /etc/ceph/ceph.conf

ssh c001 "mkdir -p /var/lib/ceph/mds/mds.0; 
ceph auth get-or-create mds.0 mds 'allow ' osd 'allow *' mon 'allow rwx' > /var/lib/ceph/mds/mds.0/mds.0.keyring; 
service ceph start mds.0"

sleep 3

ceph -s
ceph mds stat

echo
echo ---- creating ceph FS ----
echo 
ceph osd pool create cephfs_data 256
ceph osd pool create cephfs_metadata 256
ceph fs new cephfs cephfs_metadata cephfs_data
ceph fs ls
ceph mds stat

echo
echo ---- mounting cephFS with kernel driver ----
echo
grep key /etc/ceph/ceph.client.admin.keyring | awk '{print $3}' > /etc/ceph/adminkey
mkdir -p /mnt/kernel_cephfs
mount -t ceph 172.16.0.1:6789:/ /mnt/kernel_cephfs -o name=admin,secretfile=/etc/ceph/adminkey



