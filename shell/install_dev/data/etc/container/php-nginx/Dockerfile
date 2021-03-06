FROM ubuntu:14.04
MAINTAINER prozhou <zhoushengzheng@gmail.com>

WORKDIR /etc/apt
ADD soft/ /opt/soft

RUN mv /opt/soft/sources.list sources.list && \
    apt-get update

RUN   sudo apt-get install wget curl wget software-properties-common python-software-properties make \
	libxml2 libxml2-dev libevent-1.4-2 libevent-dev bzip2 libbz2-dev \
	libcurl3-gnutls libcurl4-gnutls-dev libpng12-0 libpng12-dev libjpeg62 libjpeg62-dev  \
	libfreetype6 libfreetype6-dev libmcrypt4 libmcrypt-dev zlib1g-dev libtidy-dev \
	libmysqlclient-dev  libmysqld-dev libltdl-dev libssl-dev openssl autoconf cron vim openssh-server  \
	build-essential -y
    
RUN   mkdir -p /opt/soft/

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


RUN mkdir -p /opt/build && \
    tar zxf /opt/soft/gd-2.0.33.tar.gz -C /opt/build

WORKDIR /opt/build/gd-2.0.33
RUN ./configure --prefix=/etc/php5/gd2 && \
     make && make install

	 
RUN tar jxf /opt/soft/php-5.3.29.tar.bz2 -C /opt/build
WORKDIR /opt/build/php-5.3.29
RUN mkdir /usr/include/freetype2/freetype && \
    ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h && \
	./configure \
	--prefix=/etc/php5 \
	--enable-fpm \
	--with-mysql=/usr/share/mysql \
	--with-config-file-path=/etc/php5/etc \
	--with-openssl \
	--enable-mbstring \
	--with-zlib \
	--enable-xml \
	--with-gd=/etc/php5/gd2 \
	--enable-bcmath \
	--with-mcrypt \
	--with-iconv \
	--enable-pcntl \
	--enable-shmop \
	--enable-simplexml \
	--enable-ftp \
	--with-fpm-user=www-data \
    --with-fpm-group=www-data &&\
	make && make install 

RUN \
    cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && \
    chmod +x /etc/init.d/php-fpm && \
    mv /etc/php5/etc/php-fpm.conf.default /etc/php5/etc/php-fpm.conf && \
    cp /opt/build/php-5.3.29/php.ini-production /etc/php5/etc/php.ini && \
    ln -s /etc/php5/bin/php /usr/bin/php && \
    ln -s /etc/php5/bin/php-config /usr/bin/php-config && \
    ln -s /etc/php5/bin/phpize /usr/bin/phpize && \
    head -n 937 /opt/build/php-5.3.29/php.ini-production > /etc/php5/etc/php.ini && \
    tail -n+1000 /opt/build/php-5.3.29/php.ini-production >> /etc/php5/etc/php.ini && \
    echo 'detect_unicode = Off' >> /etc/php5/etc/php.ini
RUN \
    sed -i 's/max_input_time = 30/max_input_time = 60/g' /etc/php5/etc/php.ini && \
    sed -i 's/display_errors = Off/display_errors = On/g' /etc/php5/etc/php.ini && \
    sed -i 's/max_execution_time = 30/max_execution_time = 60/g' /etc/php5/etc/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php5/etc/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 16M/g' /etc/php5/etc/php.ini && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/php5/etc/php.ini && \
    sed -i 's@;date.timezone =@date.timezone = "Europe/Moscow"@g' /etc/php5/etc/php.ini && \
    sed -i 's/pm.max_children = 5/pm.max_children = 8/g' /etc/php5/etc/php-fpm.conf && \
    sed -i 's@;pm.status_path = /status@pm.status_path = /fpm-status@g' /etc/php5/etc/php-fpm.conf && \
    sed -i 's@;ping.path = /ping@ping.path = /fpm-ping@g' /etc/php5/etc/php-fpm.conf && \
    sed -i 's@127.0.0.1:9000@0.0.0.0:9000@g' /etc/php5/etc/php-fpm.conf && \
    update-rc.d php-fpm defaults



RUN mkdir -p /opt/build && \
    tar zxf /opt/soft/memcache-2.2.7.tgz -C /opt/build
WORKDIR /opt/build/memcache-2.2.7
RUN /usr/bin/phpize && \
	./configure --with-php-config=/usr/bin/php-config && \
     make && make install && \
	 cp modules/memcache.so /etc/php5/lib/php/extensions/no-debug-non-zts-20090626/
	 
RUN  \
	 echo 'extension=/etc/php5/lib/php/extensions/no-debug-non-zts-20090626/memcache.so' >> /etc/php5/etc/php.ini 
	
WORKDIR /opt/build/php-5.3.29/ext/curl
RUN /usr/bin/phpize && \
	./configure --with-php-config=/usr/bin/php-config && \
     make && make install && \
	 cp modules/curl.so /etc/php5/lib/php/extensions/no-debug-non-zts-20090626/
	 
RUN  \
	 echo 'extension=/etc/php5/lib/php/extensions/no-debug-non-zts-20090626/curl.so' >> /etc/php5/etc/php.ini 



ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN touch /var/log/cron.log



#do clean up
RUN   sudo apt-get autoclean  && \
      sudo apt-get clean  && \
      sudo apt-get autoremove && \
      sudo rm -rf /opt
WORKDIR /tmp
RUN   sudo rm -rf *

# Define working directory.
WORKDIR /

RUN echo '#!/bin/bash' > /init.sh && \
    echo 'service php-fpm start' >> /init.sh && \
    echo 'service ssh start' >> /init.sh && \
    echo '/etc/nginx/nginx' >>/init.sh &&\
    echo '/bin/bash' >>/init.sh &&\
    chmod +x /init.sh
CMD ["/init.sh"]

# Expose ports.
VOLUME ["/opt"]
EXPOSE 9000  80


