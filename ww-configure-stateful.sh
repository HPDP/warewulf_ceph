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
	echo "If omitted, rootfs = fill, swap = $SWAPDEFAULT, and"
    echo "disk = $DISKDEFAULT."
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
ROOTP=$DISK"2"
SWAPP=$DISK"3"

echo
echo "Configuring stateful provisioning for $NODE, using :"
echo "    filesystems=\"mountpoint=/boot:dev=$BOOTP:type=ext4:size=500,dev=$SWAPP:type=swap:size=$SWAPSIZE,mountpoint=/:type=ext4:dev=$ROOTP:size=fill\""
echo "    diskformat=$ROOTP,$SWAPP"
echo "    diskpartition=$DISK"
echo "    bootloader=$DISK"
echo

wwsh << EOF
quiet
object $NODE -s filesystems="mountpoint=/boot:dev=$BOOTP:type=ext4:size=500,dev=$SWAPP:type=swap:size=$SWAPSIZE,mountpoint=/:type=ext4:dev=$ROOTP:size=fill"
object $NODE -s diskformat=$ROOTP,$SWAPP,$BOOTP
object $NODE -s diskpartition=$DISK
object $NODE -s bootloader=$DISK
EOF

echo
echo
echo "-----------------------------------------------------"
echo " $NODE has been set to boot from $DISK, with $ROOTP as "
echo " the / partition and $SWAPP as swap."
echo
echo " Make sure the VNFS for $NODE has a kernel and grub  "
echo " installed!"
echo " After you've provisioned $NODE, remember to do: "
echo "     wwsh \"object $NODE -s bootlocal=1\""
echo " to set the node to boot from its disk."
echo "-----------------------------------------------------"
echo
