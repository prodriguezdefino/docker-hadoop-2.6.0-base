#!/bin/bash

echo "Adding the machine $2 to the cluster as slave."

ssh $1 bash -c "'
/etc/add-slave.sh $2 $3 
'"

