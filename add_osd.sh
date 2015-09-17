#!/bin/bash

## cluster uuid
aid=`grep fsid /etc/ceph/ceph.conf | awk '{print $3}'`
## assuming you have sdb as SSD disk for journal and sdc/d/e 3 disks for data

## partition the ssd disk for journal
parted -s /dev/sdb mklabel gpt
parted -s /dev/sdb mkpart primary 0% 33%
parted -s /dev/sdb mkpart primary 34% 66%
parted -s /dev/sdb mkpart primary 67% 100%

## partition the osd data disk, ceph-disk does it for you
#parted -s /dev/sdc mklabel gpt
#parted -s /dev/sdc mkpart primary xfs 0% 100%
#mkfs.xfs /dev/sdc -f

#parted -s /dev/sdd mklabel gpt
#parted -s /dev/sdd mkpart primary xfs 0% 100%
#mkfs.xfs /dev/sdd -f

#parted -s /dev/sde mklabel gpt
#parted -s /dev/sde mkpart primary xfs 0% 100%
#mkfs.xfs /dev/sde -f

ceph-disk prepare --cluster ceph --cluster-uuid $aid --fs-type xfs /dev/sdc /dev/sdb1
ceph-disk prepare --cluster ceph --cluster-uuid $aid --fs-type xfs /dev/sdd /dev/sdb2
ceph-disk prepare --cluster ceph --cluster-uuid $aid --fs-type xfs /dev/sde /dev/sdb3

ceph-disk activate /dev/sdc1
ceph-disk activate /dev/sdd1
ceph-disk activate /dev/sde1

sleep 3

ceph -s
ceph osd tree