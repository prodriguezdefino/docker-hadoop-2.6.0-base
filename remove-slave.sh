#!/bin/bash

echo "connected in $HOSTNAME"

. /etc/remove-node.sh $1

# will remove the slave node in the hadoop conf
cp /usr/local/hadoop/etc/hadoop/slaves /usr/local/hadoop/etc/hadoop/slaves.old
grep -v $1 /usr/local/hadoop/etc/hadoop/slaves.old > /usr/local/hadoop/etc/hadoop/slaves

echo "modified slave file: "
echo " "
cat /usr/local/hadoop/etc/hadoop/slaves
echo " "
echo "********************************"

