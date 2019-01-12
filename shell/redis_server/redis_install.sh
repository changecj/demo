#!/usr/bin/env bash
#安装编译工具
yum install -y wget  make gcc gcc-c++ zlib-devel openssl openssl-devel pcre-devel kernel keyutils  patch perl
cp redis_start.sh /etc/init.d/redis
chmod 775 -R /etc/init.d/redis
chkconfig --add redis  #添加开启启动
chkconfig --level 2345 redis on  #设置启动级别


#clean up
service redis stop

#安装tcl组件包（安装Redis需要tcl支持）
wget  http://downloads.sourceforge.net/tcl/tcl8.6.6-src.tar.gz
tar  zxvf  tcl8.6.6-src.tar.gz  #解压
cd tcl8.6.6 #进入安装目录
cd unix
./configure --prefix=/usr   --without-tzdata    --mandir=/usr/share/man $([ $(uname -m) = x86_64 ] && echo --enable-64bit)   #配置
make #编译
sed -e "s@^\(TCL_SRC_DIR='\).*@\1/usr/include'@"  -e "/TCL_B/s@='\(-L\)\?.*unix@='\1/usr/lib@"  -i tclConfig.sh
make install  #安装
make install-private-headers
ln -v -sf tclsh8.6 /usr/bin/tclsh
chmod -v 755 /usr/lib/libtcl8.6.so
cd ../..

#安装redis
wget http://download.redis.io/redis-stable.tar.gz

tar -zxvf redis-stable.tar.gz #解压
mv redis-stable  /usr/local/redis #移动文件到安装目录
cd /usr/local/redis  #进入安装目录
make && make install #安装
cd /usr/local/redis/src
mkdir -p /usr/local/bin
cp -p redis-server /usr/local/bin
cp -p redis-benchmark /usr/local/bin
cp -p redis-cli /usr/local/bin
cp -p redis-check-aof /usr/local/bin
ln -s  /usr/local/redis/redis.conf  /etc/redis.conf  #添加配置文件软连接


sed -i 's/daemonize no/daemonize yes/g' /etc/redis.conf

if ! cat /etc/sysctl.conf | grep "vm.overcommit_memory = 1" > /dev/null;then
    echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
    sysctl -p #使设置立即生效
fi

redis-server /etc/redis.conf  #启动redis服务

