#!/usr/bin/env bash
## 把安装的文件同步到各个系统上
source ./host_list.sh
if [ -e ~/.ssh/id_rsa.pub ] ;
then
ssh-keygen
fi
for host_item in $host_list
do
    echo "sync to $host_item";
    ssh-copy-id -i ~/.ssh/id_rsa.pub $host_item
done