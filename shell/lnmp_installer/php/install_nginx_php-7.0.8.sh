#!/bin/bash

rm -rf php-7.0.8
if [ ! -f php-7.0.8.tar.gz ];then
  wget http://php.net/distributions/php-7.0.8.tar.gz
fi
tar zxvf php-7.0.8.tar.gz
cd php-7.0.8
./configure --prefix=/opt/server/php \
--enable-opcache \
--with-config-file-path=/opt/server/php/etc \
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
--with-iconv \
--with-gd \
--with-xmlrpc \
--enable-mbstring \
--without-sqlite \
--with-curl \
--enable-ftp \
--with-mcrypt  \
--with-freetype-dir=/usr/local/freetype.2.1.10 \
--with-jpeg-dir=/usr/local/jpeg.6 \
--with-png-dir=/usr/local/libpng.1.2.50 \
--disable-ipv6 \
--disable-debug \
--with-openssl \
--disable-maintainer-zts \
--disable-safe-mode \
--disable-fileinfo

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make ZEND_EXTRA_LIBS='-liconv' -j$CPU_NUM
else
    make ZEND_EXTRA_LIBS='-liconv'
fi
make install
cd ..
cp ./php-7.0.8/php.ini-production /opt/server/php/etc/php.ini
#adjust php.ini
sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "/opt/server/php/lib/php/extensions/no-debug-non-zts-20121212/"#'  /opt/server/php/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /opt/server/php/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /opt/server/php/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = PRC/g' /opt/server/php/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' /opt/server/php/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /opt/server/php/etc/php.ini
#adjust php-fpm
cp /opt/server/php/etc/php-fpm.conf.default /opt/server/php/etc/php-fpm.conf
sed -i 's,user = nobody,user=www,g'   /opt/server/php/etc/php-fpm.conf
sed -i 's,group = nobody,group=www,g'   /opt/server/php/etc/php-fpm.conf
sed -i 's,^pm.min_spare_servers = 1,pm.min_spare_servers = 5,g'   /opt/server/php/etc/php-fpm.conf
sed -i 's,^pm.max_spare_servers = 3,pm.max_spare_servers = 35,g'   /opt/server/php/etc/php-fpm.conf
sed -i 's,^pm.max_children = 5,pm.max_children = 100,g'   /opt/server/php/etc/php-fpm.conf
sed -i 's,^pm.start_servers = 2,pm.start_servers = 20,g'   /opt/server/php/etc/php-fpm.conf
sed -i 's,;pid = run/php-fpm.pid,pid = run/php-fpm.pid,g'   /opt/server/php/etc/php-fpm.conf
sed -i 's,;error_log = log/php-fpm.log,error_log = /opt/log/php/php-fpm.log,g'   /opt/server/php/etc/php-fpm.conf
sed -i 's,;slowlog = log/$pool.log.slow,slowlog = /opt/log/php/\$pool.log.slow,g'   /opt/server/php/etc/php-fpm.conf
#self start
install -v -m755 ./php-7.0.8/sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm
/etc/init.d/php-fpm start
sleep 5
