#!/usr/bin/env bash

source ./common.sh
#centos 6
yum install nfs-utils rpcbind




#start server and write local to start on startup
/etc/init.d/rpcbind start
/etc/init.d/nfs start

if ! cat /etc/rc.local | grep "/etc/init.d/rpcbind start" > /dev/null;then
    echo "/etc/init.d/rpcbind start" >> /etc/rc.local
    echo "/etc/init.d/nfs start" >> /etc/rc.local
    echo "exportfs -rv" >> /etc/rc.local
fi

#create share directory
mkdir -p /data/www/wwwroot/_assets
mkdir -p /data/www/wwwroot/themes
mkdir -p /data/www/wwwroot/wap_themes
mkdir -p /data/www/wwwroot/images
mkdir -p /data/www/wwwroot/public/image
mkdir -p /data/www/wwwroot/public/images
mkdir -p /data/www/wwwroot/public/app

echo ''> /etc/exports

for ip in ${client_ip_pro[@]}
do
# make share ip
cat >> /etc/exports <<END
/data/www/wwwroot/themes   $ip(rw,sync,all_squash,anonuid=502,anongid=502)
/data/www/wwwroot/wap_themes   $ip(rw,sync,all_squash,anonuid=502,anongid=502)
/data/www/wwwroot/_assets           $ip(rw,sync,all_squash,anonuid=502,anongid=502)
/data/www/wwwroot/images  　　　　　 $ip(rw,sync,all_squash,anonuid=502,anongid=502)
/data/www/wwwroot/public/images  　 $ip(rw,sync,all_squash,anonuid=502,anongid=502)
/data/www/wwwroot/public/image 　 $ip(rw,sync,all_squash,anonuid=502,anongid=502)
/data/www/wwwroot/public/app 　 $ip(rw,sync,all_squash,anonuid=502,anongid=502)
END

done

exportfs -rv
#nfs server ip
showmount -e $server_ip



