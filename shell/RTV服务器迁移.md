# 阅视服务器迁移记录
@(硬件选择)[环境部署|系统调优|RDS迁移|缓存服务器迁移Redis]


####I.硬件选择
* 1.系统盘SSD+++40G
* 2.数据盘+++高效硬盘300G
* 3.CPU/内存++++16核 / 32G
* 4.网络++++弹性IP / 10M
* 5.系统++++CentOS-6.8 / 64
>**注意**:阿里云ECS创建时选择VPC网络，不分配公网IP.后期申请弹性IP绑定


####系统调整
1.绑定弹性公网IP
2.[数据盘格式化 / 挂载](https://help.aliyun.com/document_detail/25426.html?spm=5176.doc25446.2.3.HczGQ5)
>数据盘挂载点 **/data**

3.网络参数优化[@见附录]
	
	-----------------------------硬盘处理------------------------
	fdisk -l
	fdisk /dev/vdb
	n->p->1->回车->回车->wq
	mkfs.ext3 /dev/vdb1
	mkdir /data
	mount /dev/vdb1 /data
	写入开机启动
	vi /etc/fstab
	/dev/vdb1    /data      ext3    noatime,nodiratime      0 0

	----------------------------系统参数优化----------------------




####环境部署
1.Git安装,绑定.ssh_key

    `yum install git`
    `git config --global user.name 'system'`
    `git config --global user.user 'system@readtv.com'`
    `ssh-keygen -t rsa -C "绑定的公网IP@readtv.cn"`
    `//添加当前的pub文件到服务器`

2.Clone 环境部署脚本

    `git clone git@gitlab.huanqiugo.com:ghs/script.git`

3.环境安装
```bash
 ###交互模式安装，不勾选mysql --空格键选择与取消
 script/shell/lnmp_installer/install.sh -i
 ###环境选择：php-5.3.29、nginx-1.4.4
 ###环境安装目录：/data/server
```
4.nginx配置
```bash
cp nginx/conf/vhost/ghs.net.conf.dist  ghs.net.conf
###开启https协议
cp nginx/conf/vhost/https.ghs.net.conf.dist https.ghs.net.conf
###################################
###    启动服务                #####
###    service nginx start    #####
###    service php-fpm start  #####
###################################
```

5.LNMP配置优化
 > **注意**： 具体参考现在服务器配置
 > 1.php-fpm 子进程优化；2.nginx work_process 
 >

####代码部署
1.同步项目代码
```bash
###修改代码服务器ip为现在的主服务器
###文件路径：script/shell/rsync/common.sh
vim common.sh
script/shell/rsync/client.sh
```
2.挂载资源服务器
```bash
###在资源服务器上添加挂载点
vim /etc/exports
###添加以下信息-修改IP为新服务器IP
/data/www/wwwroot/themes   10.31.18.154(rw,sync,all_squash,anonuid=502,anongid=502)
/data/www/wwwroot/wap_themes   10.31.18.154(rw,sync,all_squash,anonuid=502,anongid=502)
/data/www/wwwroot/_assets           10.31.18.154(rw,sync,all_squash,anonuid=502,anongid=502)
/data/www/wwwroot/images  　　　　　 10.31.18.154(rw,sync,all_squash,anonuid=502,anongid=502)
/data/www/wwwroot/public/images  　 10.31.18.154(rw,sync,all_squash,anonuid=502,anongid=502)
/data/www/wwwroot/public/image 　 10.31.18.154(rw,sync,all_squash,anonuid=502,anongid=502)
/data/www/wwwroot/public/app 　 10.31.18.154(rw,sync,all_squash,anonuid=502,anongid=502)
###修改nfs-servier_ip
###文件路径：script/shell/nfs_share/common.sh
vim common.sh
###运行nfs挂载脚本
script/shell/nfs_share/client.sh
###################################
###    启动服务                #####
###    service nginx start    #####
###    service php-fpm start  #####
###################################
```

####缓存服务器Redis
	登录redis服务器(图片服务器)：10.31.18.142/47.93.231.109
```bash
###修改iptables，指定IP开放端口
vi /etc/system/iptables
###修改内容参见已有条目
###修改完后记得重启防火墙服务
service iptables restart
```


####RDS数据库实例
	**登录阿里云控制台修改**
```
修改RDS白名单
路径RDS控制台->数据安全性->白名单设置
添加当前主机IP至白名单列表
```

####ERP系统HOST配置
    ##--erp--
    10.1.3.112  erp.ghs.net

####附录
	
	注：网络参数优化
	***标注****
	对TCP/IP网络参数进行调整
	
	vi /etc/sysctl.conf
	#net.ipv4.tcp_max_syn_backlog = 1024
	#net.ipv6.conf.all.disable_ipv6 = 1
	#net.ipv6.conf.default.disable_ipv6 = 1
	#net.ipv6.conf.lo.disable_ipv6 = 1
	#####新增的内核TCP参数
	net.ipv4.tcp_fin_timeout = 20
	# net.ipv4.tcp_keepalive_time = 1200 -------
	net.ipv4.tcp_tw_reuse = 1
	#表示开启TCP连接中TIME-WAIT sockets的快速回收
	net.ipv4.tcp_tw_recycle = 1
	net.ipv4.ip_local_port_range = 1024 65000
	net.ipv4.tcp_max_syn_backlog = 8192
	配置生效--
	sysctl -p

	定时校正服务器时间
	yum install ntp
	crontab -e
	*/5 * * * * ntpdate ntp.api.bz