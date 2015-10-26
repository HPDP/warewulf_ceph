#!/bin/sh

## virtualbox 5.0.8 and above

vboxmanage createvm --name wulf --ostype RedHat_64 --register
vboxmanage modifyvm wulf --memory 1024 --nic1 nat
vboxmanage modifyvm wulf --nic2 intnet --intnet2 eth1
vboxmanage storagectl wulf --name "IDE" --add ide --bootable on
vboxmanage storageattach wulf --storagectl "IDE" --type dvddrive --port 0 --device 0 --medium ~/Downloads/CentOS-7-x86_64-Minimal-1503-01.iso
vboxmanage storagectl wulf --name "SATA" --add sata --hostiocache on --bootable on
vboxmanage createmedium disk --filename wulf.vdi --size 8192
vboxmanage storageattach wulf --storagectl "SATA" --port 0 --device 0 --type hdd --medium wulf.vdi
vboxmanage modifyvm wulf --boot1 disk
VBoxManage modifyvm wulf --natpf1 "guestssh,tcp,,2222,,22"

for i in `seq -w 001 003`; do
    node=c$i;
    echo creating node: $node;

    vboxmanage createvm --name $node --ostype RedHat_64 --register;
    vboxmanage modifyvm $node --memory 1024 
    vboxmanage modifyvm $node --nic1 intnet --intnet1 eth1
    vboxmanage storagectl $node --name "SATA" --add sata --hostiocache on --bootable on
    vboxmanage modifyvm $node --boot1 net --boot2 disk
    for d in `seq 1 5`; do
	diskname=c$i-$d.vdi;
	vboxmanage createmedium disk --filename $diskname --size 8192
	vboxmanage storageattach $node --storagectl "SATA" --port $(($d-1)) --device 0 --type hdd --medium $diskname
    done
done
