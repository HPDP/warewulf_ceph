#!/bin/bash

service ceph restart

node=$1
nodeip=$2

mkdir -p /var/lib/ceph/mon/ceph-$node /tmp/$node
ceph auth get mon. -o /tmp/$node/monkeyring
ceph mon getmap -o /tmp/$node/monmap
ceph-mon -i $node --mkfs --monmap /tmp/$node/monmap --keyring /tmp/$node/monkeyring

ceph mon add $node $nodeip:6789

sleep 3

ceph -s
