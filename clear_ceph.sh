#!/bin/bash

pdsh rm -fr /etc/ceph
pdsh rm -fr /var/lib/ceph
pdsh rm -fr /tmp/c00*
pdsh rm -fr /tmp/cep*
pdsh rm -fr /tmp/mon*
pdsh service ceph stop