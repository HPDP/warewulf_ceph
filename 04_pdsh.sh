#!/bin/bash

cd ~/
git clone https://code.google.com/p/pdsh/
cd pdsh
./configure --with-ssh
make
make install

cat > /etc/profile.d/pdsh.sh <<EOF
# setup pdsh for cluster users
export PDSH_RCMD_TYPE='ssh'
export WCOLL='/etc/pdsh/machines'
EOF

mkdir -p /etc/pdsh
grep enps03 /etc/hosts | awk '{print $3}' > /etc/pdsh/machines 
exec -l $SHELL
