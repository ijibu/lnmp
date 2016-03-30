##############################################
## nginx1.4.5安装脚本
##			云更新web组（liuhui05）	
#############################################

#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install this shell script"
    exit 1
fi

mkdir -p /var/log/nginx
chown www.www /var/log/nginx
mkdir -p /root/download
cd /root/download

yum -y install pcre-devel zlib zlib-devel openssl openssl-devel

groupadd www
useradd -s /sbin/nologin -g www www
ulimit -SHn 65535

ldconfig

wget http://nginx.org/download/nginx-1.9.6.tar.gz
tar zxvf nginx-1.9.6.tar.gz
cd nginx-1.9.6/
./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-pcre
make && make install

cd ../

#wget -c "http://wiki.nginx.org/index.php?title=RedHatNginxInitScript&action=raw&anchor=nginx" -O init.d.nginx
#cp init.d.nginx /etc/init.d/nginx
#chmod +x /etc/init.d/nginx
#需要手动配置下/etc/init.d/nginx

#chkconfig --add nginx
#chkconfig nginx on

#/etc/init.d/nginx start
/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
#ps aux |grep nginx