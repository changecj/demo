#!/usr/bin/env bash

source ./common.sh

for ip in ${client_ip_dev[@]}
do
# make share ip
cat >> /etc/exports <<END
/data/www/nfs/testpublic/image   $ip(rw,sync,all_squash,anonuid=502,anongid=502)
/data/www/nfs/testpublic/images           $ip(rw,sync,all_squash,anonuid=502,anongid=502)
END

done

exportfs -rv
#nfs server ip
showmount -e $server_ip