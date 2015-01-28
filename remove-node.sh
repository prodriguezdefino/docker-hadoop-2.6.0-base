#!/bin/bash

echo "running in $HOSTNAME"

# will remove an entry in hosts file
cp /etc/hosts /etc/hosts.old
grep -v $1 /etc/hosts.old > /etc/hosts

echo "modified hosts file: "
echo " "
cat /etc/hosts
echo " "
echo "********************************"
