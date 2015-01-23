#!/bin/bash

echo "connected in $HOSTNAME"


# will add a new slave node in the hadoop configuration.
sed -i -e '$a\' /usr/local/hadoop/etc/hadoop/slaves
echo "$1" >> /usr/local/hadoop/etc/hadoop/slaves

echo "modified slave file: "
echo " "
cat /usr/local/hadoop/etc/hadoop/slaves
echo " "
echo "********************************"

