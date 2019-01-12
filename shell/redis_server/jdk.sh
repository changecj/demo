#!/usr/bin/env bash
function downloadjdk(){
	wget --no-cookies --no-check-certificate --header \
	"Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
	"http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.tar.gz" -O "data/jdk1.7.tar.gz" && \
	cd data && tar xzvf jdk1.7.tar.gz && rm -rf *.tar.gz && mv jdk* jdk1.7 && tar czvf jdk1.7.tar.gz jdk1.7 && rm -rf jdk1.7 && cd ..
}


function jdk(){
	if [ ! -f data/jdk1.7.tar.gz ];
		then
		echo "downloading jdk 1.7"
		downloadjdk
	fi

	JDK_VERSION=1.7
	mkdir -p /usr/lib/jvm
	if [ ! -d "/usr/lib/jvm/jdk${JDK_VERSION}" ]; then
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