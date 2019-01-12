#!/usr/bin/env bash

#docker devevlop enviroment
dockerpull(){
	declare -a myarray     
	myarray=(
	         mysql:5.6  ubuntu:14.04 gitlab/gitlab-ce
	    )
	        

	for i in ${myarray[@]};
	do
	image=$(echo $i | awk 'BEGIN {FS = ":"} {print $1}')
	if (( $(docker images  | awk '{print $1}' | grep ^$image | wc -l)==0 )) ;then
	  docker pull $i
	fi
	done
}

dockerpull