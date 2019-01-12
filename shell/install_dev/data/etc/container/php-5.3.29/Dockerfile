FROM ubuntu:14.04
MAINTAINER prozhou <zhoushengzheng@gmail.com>


WORKDIR /etc/apt
ADD soft/ /opt/soft

RUN mv /opt/soft/sources.list sources.list && \
    apt-get update

RUN   usermod -u 1000 www-data
RUN   sudo apt-get install wget curl wget software-properties-common python-software-properties make \
	libxml2 libxml2-dev libevent-1.4-2 libevent-dev bzip2 libbz2-dev \
	libcurl3-gnutls libcurl4-gnutls-dev libpng12-0 libpng12-dev libjpeg62 libjpeg62-dev  \
	libfreetype6 libfreetype6-dev libmcrypt4 libmcrypt-dev zlib1g-dev libtidy-dev \
	libmysqlclient-dev  libmysqld-dev libltdl-dev libssl-dev openssl autoconf cron vim openssh-server git ntpdate -y
    
RUN   mkdir -p /opt/soft/

ADD soft/ /opt/soft
	
#gd
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
        --with-xmlrpc \
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
# xdebug
RUN mkdir -p /opt/build && \
    tar zxf /opt/soft/xdebug-2.1.1.tgz -C /opt/build
WORKDIR /opt/build/xdebug-2.1.1
RUN /usr/bin/phpize && \
	./configure --with-php-config=/usr/bin/php-config && \
     make && make install && \
	 cp modules/xdebug.so /etc/php5/lib/php/extensions/no-debug-non-zts-20090626/
	 
RUN  \
	 echo 'zend_extension=/etc/php5/lib/php/extensions/no-debug-non-zts-20090626/xdebug.so' >> /etc/php5/etc/php.ini && \
         echo 'xdebug.remote_enable=1 ' >> /etc/php5/etc/php.ini && \
         echo 'xdebug.remote_autostart=1' >> /etc/php5/etc/php.ini && \
         echo 'xdebug.remote_connect_back=1' >> /etc/php5/etc/php.ini && \
	 echo 'xdebug.remote_handler=dbgp' >> /etc/php5/etc/php.ini && \
	 echo 'xdebug.remote_port=9000' >> /etc/php5/etc/php.ini && \
	 echo 'xdebug.idekey=PHPSTORM' >> /etc/php5/etc/php.ini 


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

###soap extension
WORKDIR /opt/build/php-5.3.29/ext/soap
RUN /usr/bin/phpize && \
	./configure --with-php-config=/usr/bin/php-config && \
     make && make install && \
	 cp modules/soap.so /etc/php5/lib/php/extensions/no-debug-non-zts-20090626/
	 
RUN  \
	 echo 'extension=/etc/php5/lib/php/extensions/no-debug-non-zts-20090626/soap.so' >> /etc/php5/etc/php.ini 


ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN touch /var/log/cron.log

#ssh service

RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN echo "root:root" | chpasswd
RUN echo "admin   ALL=(ALL)       ALL" >> /etc/sudoers


#install composer
RUN  mv /opt/soft/composer.phar   /usr/bin/composer

RUN  /usr/bin/composer global config github-oauth.github.com 9b2e53a71cf0433889b99b3f28b13b109efd945f

#install goagent crt
RUN  mv /opt/soft/CA.crt   /CA.crt && \ 
          mv /opt/soft/pxy     /usr/local/bin/ &&\
           chmod 777 -R /usr/local/bin/pxy 


#do clean up
RUN   sudo apt-get autoclean  && \
      sudo apt-get clean  && \
      sudo apt-get autoremove && \
      sudo rm -rf /opt
WORKDIR /tmp
RUN   sudo rm -rf * &&  cp /CA.crt  /tmp 

# Define working directory.
WORKDIR /
RUN echo '#!/bin/bash' > /init.sh && \
    echo 'service php-fpm start' >> /init.sh && \
    echo 'service ssh start' >> /init.sh && \
    echo 'cron -f' >> /init.sh && \
    echo 'tail -f /etc/php5/var/log/php-fpm.log' >> /init.sh && \
    echo 'export PHP_IDE_CONFIG=serverName=172.17.0.1' >>/root/.bashrc && \
    echo 'alias phpd="php -d xdebug.remote_host=172.17.0.1"' >>/root/.bashrc && \
    echo 'cd /opt/htdocs' >>/root/.bashrc && \
    chmod +x /init.sh
CMD ["/init.sh"]
# Expose ports.
VOLUME ["/opt"]
EXPOSE 9000 22
