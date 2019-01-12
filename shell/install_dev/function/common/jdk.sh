#!/usr/bin/env bash
#http://www.linuxidc.com/Linux/2016-06/132678.htm

function downloadjdk(){
	 wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-x64.tar.gz -O "data/jdk1.8.tar.gz" && \
	cd data && tar xzvf jdk1.8.tar.gz && rm -rf *.tar.gz && mv jdk* jdk1.8 && tar czvf jdk1.8.tar.gz jdk1.8 && rm -rf jdk1.8 && cd ..
}


function jdk(){


	JDK_VERSION=1.8
	mkdir -p /usr/lib/jvm
	if [ ! -d "/usr/lib/jvm/jdk${JDK_VERSION}" ]; then
        if [ ! -f data/jdk1.8.tar.gz ];
            then
            echo "downloading jdk 1.8"
            downloadjdk
        fi
        JAVA_PACKAGE=data/jdk${JDK_VERSION}.tar.gz
        rm -rf /usr/lib/jvm/*
        tar zxvf $JAVA_PACKAGE  -C /usr/lib/jvm/
	  echo "export JAVA_HOME=/usr/lib/jvm/jdk${JDK_VERSION}" >>  /etc/profile
	  echo "export CLASSPATH=\".:/usr/lib/jvm/jdk${JDK_VERSION}/lib:/usr/lib/jvm/jdk${JDK_VERSION}\""  >>  /etc/profile
	  echo "export PATH=\"/usr/lib/jvm/jdk${JDK_VERSION}/bin:$PATH\"" >>  /etc/profile
	  update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk${JDK_VERSION}/bin/java 300
	  update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk${JDK_VERSION}/bin/javac 300
	fi

}

jdk 