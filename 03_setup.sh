#!/bin/bash

mysqladmin -u root password 'password'

## warewulf mysql set up
sed -i '/database user/c\database user = root' /etc/warewulf/database.conf
sed -i '/database password/c\database password = password'  /etc/warewulf/database.conf
sed -i '/database password/c\database password = password' /etc/warewulf/database-root.conf

cat > ~/.my.cnf <<EOF
[client]
user = root
password = password
EOF

chmod 0600 ~/.my.cnf

