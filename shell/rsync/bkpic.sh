#!/usr/bin/env bash

#指定运行的脚本shell
#运行脚本要给用户执行权限
backserver=10.1.1.1
bakdir=/backup
month=`date +%m`
day=`date +%d`
year=`date +%Y`
hour=`date +%k`
min=`date +%M`
dirname=$year-$month-$day-$hour-$min
mkdir -p $bakdir/$dirname

#备份conf,检测通过
gzupload=bak.tar.gz
cd /data/www
tar -zcvf $bakdir/$dirname/$gzupload ./wwwroot
#远程拷贝的目录要有可写权限
scp -r /backup/$dirname root@$backserver:/backup