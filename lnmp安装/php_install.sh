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

mkdir -p /usr/local/php
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
./configure --prefix=/usr/local/php-5.4.25 --with-config-file-path=/usr/local/php-5.4.25/etc --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-gd --with-iconv --with-zlib --enable-xml --enable-bcmath  --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --enable-ftp --enable-gd-native-ttf  --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc  --enable-zip --enable-soap --without-pear --with-gettext --enable-session --with-mcrypt --with-curl 
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
touch /usr/local/freetds/include/tds.h
touch /usr/local/freetds/lib/libtds.a
#配置/usr/local/freetds/etc/freetds.conf文件

cd /usr/local/src/php-5.4.25/ext/mssql/
/usr/local/php-5.4.25/bin/phpize 
./configure --with-php-config=/usr/local/php-5.4.25/bin/php-config --with-mssql=/usr/local/freetds
make && make install
#修改php.ini，加载mssql.so

./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-gd --with-iconv --with-zlib --enable-xml --enable-bcmath  --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --enable-ftp --enable-gd-native-ttf  --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc  --enable-zip --enable-soap --without-pear --with-gettext --enable-session --with-mcrypt --with-curl 



php7的redis扩展安装：
creating redis.la
(cd .libs && rm -f redis.la && ln -s ../redis.la redis.la)
/bin/sh /usr/local/src/phpredis-php7/libtool --mode=install cp ./redis.la /usr/local/src/phpredis-php7/modules
cp ./.libs/redis.so /usr/local/src/phpredis-php7/modules/redis.so
cp ./.libs/redis.lai /usr/local/src/phpredis-php7/modules/redis.la
PATH="$PATH:/sbin" ldconfig -n /usr/local/src/phpredis-php7/modules
----------------------------------------------------------------------
Libraries have been installed in:
   /usr/local/src/phpredis-php7/modules

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,--rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.
----------------------------------------------------------------------

Build complete.
Don't forget to run 'make test'.

Installing shared extensions:     /usr/local/php/lib/php/extensions/no-debug-non-zts-20151012/