#!/bin/bash

cp first_mon.sh /home/ceph
cp add_mon.sh /home/ceph
cp add_osd.sh /home/ceph
sleep 15

ssh c001 "/home/ceph/first_mon.sh"
sleep 15
pdsh cp -fr /home/ceph/ceph /etc
cp -fr /home/ceph/ceph /etc

ssh c002 "/home/ceph/add_mon.sh c002 172.16.0.2"
sleep 15
ssh c003 "/home/ceph/add_mon.sh c003 172.16.0.3"

ssh c001 "/home/ceph/add_osd.sh"
sleep 15
ssh c002 "/home/ceph/add_osd.sh"
sleep 15
ssh c003 "/home/ceph/add_osd.sh"

echo waiting --------
echo
sleep 200
ceph osd pool set rbd pg_num 256
echo waiting --------
echo
sleep 200
ceph osd pool set rbd pgp_num 256
echo waiting --------
echo
sleep 200

ceph -s

