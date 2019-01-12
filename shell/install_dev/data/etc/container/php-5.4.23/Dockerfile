FROM ubuntu:14.04
MAINTAINER prozhou <zhoushengzheng@gmail.com>

#install aliyun
ADD soft/ /opt/soft
WORKDIR /etc/apt
RUN mv sources.list sources.list.backup && \
cp /opt/soft/sources.list sources.list && \
apt-get update

RUN  apt-get install -y wget \
             curl wget software-properties-common python-software-properties make \
	    libxml2 libxml2-dev libevent-1.4-2 libevent-dev bzip2 libbz2-dev \
	   libcurl3-gnutls libcurl4-gnutls-dev libpng12-0 libpng12-dev libjpeg62 libjpeg62-dev  \
	   libfreetype6 libfreetype6-dev libmcrypt4 libmcrypt-dev zlib1g-dev libtidy-dev \
	   libmysqlclient-dev  libmysqld-dev libltdl-dev libssl-dev openssl autoconf cron vim
    
	
RUN  mkdir -p /opt/build
WORKDIR /opt/build

#freetype
RUN tar zxf /opt/soft/freetype-2.3.5.tar.gz -C /opt/build

WORKDIR /opt/build/freetype-2.3.5
RUN ./configure --prefix=/etc/php5/freetype && \
     make && make install

#gd
RUN tar zxf /opt/soft/gd-2.0.33.tar.gz -C /opt/build

WORKDIR /opt/build/gd-2.0.33
RUN ./configure --prefix=/etc/php5/gd2 && \
     make && make install
	 
RUN wget -O /var/tmp/php-5.4.23.tar.gz http://oss.aliyuncs.com/aliyunecs/onekey/php/php-5.4.23.tar.gz && \
    tar zxf /var/tmp/php-5.4.23.tar.gz -C /opt/build
WORKDIR /opt/build/php-5.4.23
RUN  \
	./configure --prefix=/etc/php5  \
	--with-config-file-path=/etc/php5/etc \
	--with-mysql=mysqlnd \
	--with-mysqli=mysqlnd \
	--with-pdo-mysql=mysqlnd \
	--enable-fpm \
	--enable-fastcgi \
	--enable-static \
	--enable-inline-optimization \
	--enable-sockets \
	--enable-wddx \
	--enable-zip \
	--enable-calendar \
	--enable-bcmath \
	--enable-soap \
	--with-zlib \
        --with-freetype-dir=/etc/php5/freetype \
	--with-gd=/etc/php5/gd2 \
	--enable-gd-native-ttf \
	--with-xmlrpc \
        --with-iconv \
	--enable-xml \
	--enable-mbstring \
	--without-sqlite \
	--with-curl \
	--enable-ftp \
	--with-mcrypt  \
	--disable-ipv6 \
	--disable-debug \
	--with-openssl \
	--disable-maintainer-zts \
	--disable-safe-mode \
	--disable-fileinfo \
        --enable-pcntl \
        --enable-shmop \
        --enable-simplexml \
	--with-fpm-user=www-data \
	--with-fpm-group=www-data &&\
	make && make install 

RUN \
    cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && \
    chmod +x /etc/init.d/php-fpm && \
    mv /etc/php5/etc/php-fpm.conf.default /etc/php5/etc/php-fpm.conf && \
    cp /opt/build/php-5.4.23/php.ini-production /etc/php5/etc/php.ini && \
    ln -s /etc/php5/bin/php /usr/bin/php && \
    ln -s /etc/php5/bin/php-config /usr/bin/php-config && \
    ln -s /etc/php5/bin/phpize /usr/bin/phpize && \
    head -n 937 /opt/build/php-5.4.23/php.ini-production > /etc/php5/etc/php.ini && \
    tail -n+1000 /opt/build/php-5.4.23/php.ini-production >> /etc/php5/etc/php.ini && \
    echo 'detect_unicode = Off' >> /etc/php5/etc/php.ini
RUN \
    sed -i 's/max_input_time = 30/max_input_time = 60/g' /etc/php5/etc/php.ini && \
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


# Define working directory.
WORKDIR /
RUN echo '#!/bin/bash' > /init.sh && \
    echo 'service php-fpm start' >> /init.sh && \
    echo 'tail -f /etc/php5/var/log/php-fpm.log' >> /init.sh && \
    chmod +x /init.sh

CMD ["/init.sh"]
# Expose ports.
VOLUME ["/opt"]
EXPOSE 9000
