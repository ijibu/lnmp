##############################################
## php5.4.25安装脚本，以及sql server的php安装
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

mkdir -p /usr/local/php-5.4.25
#安装基础库
yum -y install libxml2 libxml2-devel curl-devel libjpeg-devel libpng-devel

#安装libmcrypt
cd /usr/local/src
wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/attic/libmcrypt/libmcrypt-2.5.7.tar.gz 
tar -zxvf libmcrypt-2.5.7.tar.gz 
cd libmcrypt-2.5.7 
./configure
make && make install

####################################
## 安装php-5.4.25
####################################
cd /usr/local/src
wget http://cn2.php.net/distributions/php-5.4.25.tar.gz 
tar zvxf php-5.4.25.tar.gz
cd php-5.4.25
./configure --prefix=/usr/local/php-5.4.25 --with-config-file-path=/usr/local/php-5.4.25/etc --with-gd --with-iconv --with-zlib --enable-xml --enable-bcmath  --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --enable-ftp --enable-gd-native-ttf  --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc  --enable-zip --enable-soap --without-pear --with-gettext --enable-session --with-mcrypt --with-curl 
make #编译
make install #安装

cp /usr/local/src/php-5.4.25/php.ini-production /usr/local/php-5.4.25/etc/php.ini
cp /usr/local/php-5.4.25/etc/php-fpm.conf.default /usr/local/php-5.4.25/etc/php-fpm.conf
cp /usr/local/src/php-5.4.25/sapi/fpm/init.d.php-fpm.in /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm #添加执行权限

#需要手动配置下/etc/init.d/php-fpm
#需要手动配置下/usr/local/php-5.4.25/etc/php-fpm.conf
#需要手动配置下/usr/local/php-5.4.25/etc/php.ini

#chkconfig --add php-fpm
#chkconfig php-fpm on


####################################
## 安装sql server的php驱动
####################################
cd /usr/local/src
wget ftp://ftp.freetds.org/pub/freetds/stable/freetds-stable.tgz
tar zxvf freetds-stable.tgz
cd freetds-0.91/ 
./configure --prefix=/usr/local/freetds --enable-msdblib
make && make install

cd /usr/local/src/php-5.4.25/ext/mssql/
/usr/local/php-5.4.25/bin/phpize 
./configure --with-php-config=/usr/local/php-5.4.25/bin/php-config --with-mssql=/usr/local/freetds
make && make install