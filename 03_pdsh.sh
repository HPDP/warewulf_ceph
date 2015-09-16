#!/bin/bash

cd ~/
git clone https://code.google.com/p/pdsh/
cd pdsh
./configure
make
make install