#!/bin/bash

cd ~/
git clone https://code.google.com/p/pdsh/
cd pdsh
./configure --with-ssh
make
make install

echo "export PDSH_RCMD_TYPE=ssh" >> ~/.bashrc