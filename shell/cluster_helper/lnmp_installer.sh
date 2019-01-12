#!/usr/bin/env bash
## 在多台主机上安装lnmp环境
source ./host_list.sh
for host_item in $host_list
do
    echo "sync to $host_item"
    rsync -a --delete -e ssh ../lnmp_installer   root@$host_item:/data
    bash r_cmd.sh "cd /data/lnmp_installer;bash -l ./install.sh -spnd"
done