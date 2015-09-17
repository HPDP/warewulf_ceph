#!/bin/bash

aid=`uuidgen`
mkdir -p /etc/ceph

cat > /etc/ceph/ceph.conf <<EOF
[global]
fsid = $aid
public network = 172.16.0.0/24

osd pool default min size = 1
osd pool default pg num = 128
osd pool default pgp num = 128
osd journal size = 1024

[mon]
mon initial members = c001
mon host = c001,c002,c003
mon addr = 172.16.0.1,172.16.0.2,172.16.0.3

[mon.c001]
host = c001
mon addr = 172.16.0.1

[mon.c002]
host = c002
mon addr = 172.16.0.2:6789

[mon.c003]
host = c003
mon addr = 172.16.0.3:6789
EOF

## generate keyrings
ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'
ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --set-uid=0 --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow'
ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring

node=c001
nodeip=172.16.0.1
## add the first mon
monmaptool --create --add $node $nodeip --fsid $aid /tmp/monmap
mkdir -p /var/lib/ceph/mon/$node
ceph-mon --mkfs -i $node --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring

## start ceph cluster
service ceph restart

cp -r /etc/ceph /home/ceph/