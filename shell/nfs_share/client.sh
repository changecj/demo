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
fi



#挂载nfs盘
mount -t nfs $server_ip:/data/www/wwwroot/_assets /data/www/wwwroot/_assets
mount -t nfs $server_ip:/data/www/wwwroot/images /data/www/wwwroot/images
mount -t nfs $server_ip:/data/www/wwwroot/themes /data/www/wwwroot/themes
mount -t nfs $server_ip:/data/www/wwwroot/wap_themes /data/www/wwwroot/wap_themes
mount -t nfs $server_ip:/data/www/wwwroot/public/image /data/www/wwwroot/public/image
mount -t nfs $server_ip:/data/www/wwwroot/public/images /data/www/wwwroot/public/images
mount -t nfs $server_ip:/data/www/wwwroot/public/app /data/www/wwwroot/public/app

#系统启动后挂载

if ! cat /etc/rc.local | grep "mount -t" > /dev/null;then
cat >> /etc/rc.local <<END
mount -t nfs $server_ip:/data/www/wwwroot/themes /data/www/wwwroot/themes
mount -t nfs $server_ip:/data/www/wwwroot/wap_themes /data/www/wwwroot/wap_themes
mount -t nfs $server_ip:/data/www/wwwroot/_assets /data/www/wwwroot/_assets
mount -t nfs $server_ip:/data/www/wwwroot/images /data/www/wwwroot/images
mount -t nfs $server_ip:/data/www/wwwroot/public/image /data/www/wwwroot/public/image
mount -t nfs $server_ip:/data/www/wwwroot/public/images /data/www/wwwroot/public/images
mount -t nfs $server_ip:/data/www/wwwroot/public/app /data/www/wwwroot/public/app
END
fi



