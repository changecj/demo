#!/usr/bin/env bash


function charles(){
    if [ ! -f /usr/bin/charles ];
    then
        apt-key adv --keyserver pgp.mit.edu --recv-keys 1AD28806
        sudo sh -c 'echo deb https://www.charlesproxy.com/packages/apt/ charles-proxy main > /etc/apt/sources.list.d/charles.list'
        sudo apt-get update
        sudo apt-get install charles-proxy -y
    fi

}

charles