#############################################################
## CentOS-6.5-x86_64-minimal初始安装后，常用工具命令安装。
##							云更新web组（liuhui05）
#############################################################
#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install this shell script"
    exit 1
fi

yum -y install wget gcc gcc-c++ lrzsz ntp unzip

#同步时间
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate us.pool.ntp.org