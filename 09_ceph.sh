#!/bin/bash

aid=`uuidgen`
echo $aid > aid.txt
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
mon addr = 172.16.0.2

[mon.c003]
host = c003
mon addr = 172.16.0.3
EOF

## generate keyrings
ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'
ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --set-uid=0 --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow'
ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring

## /home is exported, pop /etc/ceph to all nodes
cp -r /etc/ceph /home/ceph/
cp first_mon.sh /home/ceph
cp add_mon.sh /home/ceph
cp add_osd.sh /home/ceph
sleep 5
pdsh cp -r /home/ceph/ceph /etc

ssh c001 "/home/ceph/first_mon.sh c001 172.16.0.1"
sleep 5

ssh c002 "/home/ceph/add_mon.sh c002 172.16.0.2"
sleep 3
ssh c003 "/home/ceph/add_mon.sh c003 172.16.0.3"

ssh c001 "/home/ceph/add_osd.sh"
sleep 3
ssh c002 "/home/ceph/add_osd.sh"
sleep 3
ssh c003 "/home/ceph/add_osd.sh"

