#!/usr/bin/env bash
###########
#环境搭建脚本
#author:prozhou
#email:zhoushengzheng@gmail.com
###########

#目录名称
current_dir="$(dirname $0)"


#系统信息
source "$current_dir/function/common/systeminfo.sh"
systeminfo

echo "Your system is $com_codename $com_release"
echo "Install beginning"

#安装控制器
source "$current_dir/function/common/installhelper.sh"

installhelper  font
installhelper  jdk
installhelper  charles
installhelper  aptenv
installhelper  dockerpull
installhelper  dockerenv
installhelper  dockerbuild
# install idea ide
myarray=(phpstorm pycharm datagrip webstorm)

for i in ${myarray[@]};
do
   if [ ! -d /opt/soft/dev/idea/$i ] ;then
      python3.5  $current_dir/function/common/download.py --soft $i
   fi
done



























