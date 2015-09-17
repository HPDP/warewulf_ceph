#!/bin/bash

aid=`grep fsid /etc/ceph/ceph.conf | awk '{print $3}'`
node=c001
nodeip=172.16.0.1
## add the first mon
monmaptool --create --add $node $nodeip --fsid $aid /tmp/monmap
mkdir -p /var/lib/ceph/mon/$node
ceph-mon --mkfs -i $node --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring

## start ceph cluster
service ceph restart