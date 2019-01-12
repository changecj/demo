#!/usr/bin/env bash
source ./common.sh
yum -y install rsync
killall rsync
mkdir -p /data/sh

#make password
echo "$password" > /etc/rsyncd.password
chmod 600 /etc/rsyncd.password

# make client rsync config
cat > /data/sh/rsync.sh <<END
rsync -auvrtzopgP --delete --exclude /data \
                           --exclude .git  \
                           --exclude /_assets \
                           --exclude /themes \
                           --exclude /wap_themes \
                           --exclude /public/image \
                           --exclude /public/images \
                           --exclude /public/app \
                           --password-file=/etc/rsyncd.password \
                           root@$server_ip::$module_name \
                           $client_path
END

chmod u+x /data/sh/rsync.sh

echo '*/5 * * * * root /data/sh/rsync.sh' > /etc/cron.d/rsync_site

