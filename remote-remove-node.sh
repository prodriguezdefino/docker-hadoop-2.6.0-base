#!/bin/bash

echo "Removing the slave machine $2 from the cluster."

ssh $1 bash -c "'
/etc/remove-node.sh $2
'"

