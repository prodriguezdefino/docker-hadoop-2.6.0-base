#!/bin/bash

echo "running in $HOSTNAME"

# will add an entry in hosts file for the node

echo "$1 $2" >> /etc/hosts
echo "modified hosts file: "
echo " "
cat /etc/hosts
echo " "
echo "********************************"

