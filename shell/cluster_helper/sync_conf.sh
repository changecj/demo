#!/usr/bin/env bash
#把配置文件推送到各个主机
source ./host_list.sh
file_list="nginx/conf php/etc php/php.ini"
for host_item in $host_list
do
    echo "sync to $host_item";
    for file_item in $file_list
    do
        rsync -a --delete -e ssh /data/server/$file_item/  root@$host_item:/data/server/$file_item
    done
done
echo "all done"