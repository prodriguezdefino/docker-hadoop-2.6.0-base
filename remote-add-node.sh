#!/bin/bash

echo "Adding the machine $2 to the master in order to make it accesible."

ssh $1 bash -c "'
/etc/add-node.sh $2 $3 
'"

