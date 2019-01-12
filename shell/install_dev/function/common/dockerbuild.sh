#!/bin/bash

dockerbuild(){
    declare -a myarray
    myarray=(
        mysql-5.6  nginx-1.10.1  php-5.3.29 vsftpd
            )

    for i in ${myarray[@]};
    do
    if (( $(docker images  | awk '{print $1}' | grep ^zsz/$i | wc -l)==0 )) ;then
      docker build -t zsz/$i  data/etc/container/$i/
    fi
    done
}

dockerbuild
