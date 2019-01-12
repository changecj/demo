#!/usr/bin/env bash
source ./common.sh
yum -y install rsync
killall rsync
#make secrets
echo "$user:$password" > /etc/rsyncd.secrets
chmod 600 /etc/rsyncd.secrets

# make server config
cat > /etc/rsyncd.conf <<END
uid=root
gid=root
use chroot=no
max connections=10
timeout=600
strict modes=yes
port=873
pid file=/var/run/rsyncd.pid
lock file=/var/run/rsyncd.lock
log file=/var/log/rsyncd.log
[$module_name]
path=$server_path
comment=
auth users=root
uid=root
gid=root
secrets file=/etc/rsyncd.secrets
read only=no
list=no
END

rsync --daemon

if ! cat /etc/rc.local | grep "rsync --daemon" > /dev/null;then
    echo "rsync --daemon" >> /etc/rc.local
fi

