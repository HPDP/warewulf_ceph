#!/bin/bash

cp first_mon.sh /home/ceph
cp add_mon.sh /home/ceph
cp add_osd.sh /home/ceph
sleep 3

ssh c001 "/home/ceph/first_mon.sh"
sleep 5
pdsh cp -fr /home/ceph/ceph /etc
cp -fr /home/ceph/ceph /etc

ssh c002 "/home/ceph/add_mon.sh c002 172.16.0.2"
sleep 5
ssh c003 "/home/ceph/add_mon.sh c003 172.16.0.3"

ssh c001 "/home/ceph/add_osd.sh"
sleep 5
ssh c002 "/home/ceph/add_osd.sh"
sleep 5
ssh c003 "/home/ceph/add_osd.sh"

sleep 20
ceph osd pool set rbd pg_num 256
sleep 20
ceph osd pool set rbd pgp_num 256
sleep 20

ceph -s

