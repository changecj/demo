#!/usr/bin/env bash
#remote command
source ./host_list.sh
cmd=$1
for host_item in $host_list
do
    echo "send $cmd to $host_item";
    ssh root@$host_item " $cmd "
done
echo "all done"
