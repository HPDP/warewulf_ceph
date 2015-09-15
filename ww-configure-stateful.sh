#!/bin/bash

# ww-configure-stateful.sh
#   Script to set up basic stateful provisioning with Warewulf.
#   Adam DeConinck @ R Systems, 2011
#   modified by Jimi Chu, Harvard Medical School 2015

NODE=$1
SWAPSIZE=$2
DISK=$3

SWAPDEFAULT=4096
DISKDEFAULT="sda"

if [ -z "$NODE" ]; then
	echo
	echo "$0: Configure a node for stateful provisioning under Warewulf"
	echo "Usage: $0 nodename [swap_in_mb disk]"
	echo "If omitted, rootfs = fill, swap = $SWAPDEFAULT, and disk = $DISKDEFAULT."
	echo "REMEMBER: If you're going to do this, make sure you have a "
	echo "kernel and grub installed in your VNFS!"
	echo
	exit 1
fi

if [ -z "$SWAPSIZE" ]; then
	SWAPSIZE=$SWAPDEFAULT;
fi
if [ -z "$DISK" ]; then
    DISK=$DISKDEFAULT
fi

BOOTP=$DISK"1"
SWAPP=$DISK"2"
ROOTP=$DISK"3"

wwsh << EOF
object $NODE -s filesystems="mountpoint=/boot:dev=$BOOTP:type=xfs:size=350,mountpoint=swap,dev=$SWAPP:type=swap:size=$SWAPSIZE,mountpoint=/:type=xfs:dev=$ROOTP:size=fill"
object $NODE -s diskformat=$BOOTP,$SWAPP,$ROOTP
object $NODE -s diskpartition=$DISK
object $NODE -s bootloader=$DISK
EOF

echo
echo " Make sure the VNFS for $NODE has a kernel and grub  "
echo " installed!"
echo " After you've provisioned $NODE, remember to do: "
echo "     wwsh \"object $NODE -s bootlocal=1\""
echo " to set the node to boot from its disk."
echo "-----------------------------------------------------"
echo
