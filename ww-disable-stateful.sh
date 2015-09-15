#!/bin/bash

NODE=$1

if [ -z "$NODE" ]; then
	echo
	echo "$0: Unset variables for stateful provisioning"
	echo "Usage: $0 nodename"
	echo
	exit 1
fi

## if set to NORMAL/UNDEF, will re-provision the node
wwsh << EOF
object modify -s bootlocal=EXIT $NODE
EOF


