FROM ubuntu:14.04
MAINTAINER prozhou <zhoushengzheng@gmail.com>


WORKDIR /etc/apt
ADD soft/ /opt/soft

RUN mv /opt/soft/sources.list sources.list && \
    apt-get update

RUN   sudo apt-get install wget curl wget software-properties-common python-software-properties make \
	libxml2 libxml2-dev libevent-1.4-2 libevent-dev bzip2 libbz2-dev \
	libcurl3-gnutls libcurl4-gnutls-dev  \
	libmcrypt4 libmcrypt-dev  \
	libssl-dev openssl autoconf cron vim build-essential -y
    
RUN   mkdir -p /opt/soft/

ADD soft/ /opt/soft
	
#gd
RUN mkdir -p /opt/build && \
     tar zxf /opt/soft/nginx-1.10.1.tar.gz -C /opt/build && \
     tar jxf /opt/soft/pcre-8.39.tar.bz2 -C /opt/build && \
     tar zxf /opt/soft/zlib-1.2.8.tar.gz -C /opt/build

WORKDIR /opt/build/nginx-1.10.1
RUN ./configure  \       
    --sbin-path=/etc/nginx/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --with-http_ssl_module \
    --with-pcre=/opt/build/pcre-8.39 \
    --with-zlib=/opt/build/zlib-1.2.8 && \
     make && make install

RUN  usermod -u 1000 www-data
ADD  ./soft/nginx.conf      /etc/nginx/nginx.conf
ADD  ./soft/sites-enabled/*   /etc/nginx/conf.d/
RUN  mkdir /opt/htdocs && mkdir /opt/log && mkdir /opt/log/nginx
RUN  chown -R www-data.www-data /opt/htdocs /opt/log
WORKDIR /
RUN echo '#!/bin/bash' > /init.sh && \
    echo '/etc/nginx/nginx -g "daemon off;"' >> /init.sh && \
    chmod +x /init.sh
RUN  sudo rm -rf /opt/soft  /opt/build && sudo apt-get autoremove && sudo apt-get autoclean 
CMD ["/init.sh"]

EXPOSE 80
VOLUME ["/opt"]

