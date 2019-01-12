#!/usr/bin/env bash
#推送web程序同步到各个系统上(除数据外的文件)
source ./host_list.sh
file_list="app config demo themes index.php license.txt readme.txt rpc.txt"
for host_item in $host_list
do
    echo "sync to $host_item";
    for file_item in $file_list
    do
        rsync -a --delete -e ssh /data/www/wwwroot/$file_item  root@$host_item:/data/www/wwwroot
    done
done
echo "all done"