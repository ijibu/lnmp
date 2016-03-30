##############################################
## centos7下面nginx+mysql+php安装脚本
##			ijibu(ijibu.com@gmail.com)	
#############################################

#软件版本号
nginx_version="nginx-1.9.6"
php_version="php-7.0.0RC6"
mysql_version="mysql-5.7.9"

#软件下载地址
nginx_download_url="http://nginx.org/download/nginx-1.9.6.tar.gz"
php_download_url="https://downloads.php.net/~ab/php-7.0.0RC6.tar.gz"
mysql_download_url="http://cdn.mysql.com/Downloads/MySQL-5.7/mysql-5.7.9.tar.gz"

#软件安装地址
nginx_install_path="/usr/local/nginx"
php_install_path="/usr/local/php"
mysql_install_path="/usr/local/mysql"

#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install this shell script"
    exit 1
fi

echo "创建相关目录"
mkdir -p $nginx_install_path
mkdir -p $php_install_path
mkdir -p $mysql_install_path
mkdir -p /usr/local/src
mkdir -p /var/log/nginx


echo "安装系统工具包"
yum -y install wget gcc gcc-c++ lrzsz ntp unzip pcre-devel zlib zlib-devel openssl openssl-devel

#同步时间
echo "同步系统时间"
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate us.pool.ntp.org

echo "创建相关用户"
groupadd www
useradd -s /sbin/nologin -g www www

echo "下载相关软件包"
cd /usr/local/src
wget $nginx_download_url
wget $php_download_url
wget $mysql_download_url
wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/attic/libmcrypt/libmcrypt-2.5.7.tar.gz 


echo "开始安装nginx..........."
echo 
chown www.www /var/log/nginx

tar zxvf nginx-1.9.6.tar.gz
cd nginx-1.9.6/
./configure --user=www --group=www --prefix=$nginx_install_path --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-pcre
make && make install

cd ../

#wget -c "http://wiki.nginx.org/index.php?title=RedHatNginxInitScript&action=raw&anchor=nginx" -O init.d.nginx
#cp init.d.nginx /etc/init.d/nginx
#chmod +x /etc/init.d/nginx
#需要手动配置下/etc/init.d/nginx
echo "需要手动配置下/etc/init.d/nginx"

chkconfig --add nginx
chkconfig nginx on

/etc/init.d/nginx start
/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
#ps aux |grep nginx
echo "nginx安装完成"
echo "需要手动配置下/etc/init.d/nginx"


#安装基础库
yum -y install libxml2 libxml2-devel curl-devel libjpeg-devel libpng-devel

#安装libmcrypt
cd /usr/local/src
tar -zxvf libmcrypt-2.5.7.tar.gz 
cd libmcrypt-2.5.7 
./configure
make && make install

echo "####################################
	## 安装php-5.4.25
	####################################"
cd /usr/local/src
tar zvxf $php_version.tar.gz
cd $php_version
./configure --prefix=$php_install_path --with-config-file-path=$php_install_path/etc --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-gd --with-iconv --with-zlib --enable-xml --enable-bcmath  --enable-shmop --enable-sysvsem --enable-inline-optimization  --enable-mbregex --enable-fpm --enable-mbstring --enable-ftp --enable-gd-native-ttf  --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc  --enable-zip --enable-soap --without-pear --with-gettext --enable-session --with-mcrypt --with-curl 
make #编译
make install #安装

cd /usr/local/src
cp $php_version/php.ini-production $php_install_path/etc/php.ini
cp $php_version/sapi/fpm/php-fpm.conf $php_install_path/etc/php-fpm.conf
cp $php_version/sapi/fpm/init.d.php-fpm.in /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm #添加执行权限

#需要手动配置下/etc/init.d/php-fpm
#需要手动配置下/usr/local/php-5.4.25/etc/php-fpm.conf
#需要手动配置下/usr/local/php-5.4.25/etc/php.ini

chkconfig --add php-fpm
chkconfig php-fpm on

#安装bison
echo "正在安装bison******************"
cd /usr/local/src
wget ftp://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.gz
tar xf bison-3.0.4.tar.gz
cd bison-3.0.4
./configure 
make && make install

#安装ncurses
echo "正在安装ncurses******************"
cd /usr/local/src
wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz
tar xf ncurses-6.0.tar.gz
cd ncurses-6.0
./configure 
make && make install

#安装CMAKE
echo "正在安装CMAKE******************"
cd /usr/local/src
wget https://cmake.org/files/v3.3/cmake-3.3.2.tar.gz
tar xf cmake-3.3.2.tar.gz
cd cmake-3.3.2
./configure 
gmake && make install

#https://typecodes.com/web/centos7compilemysql.html
#http://www.tuicool.com/articles/E3yYV3
#安装mysql
echo "正在安装mysql******************"
##############################################
## 从MySQL 5.7.5开始Boost库是必需的，下载Boost库，
## 在解压后复制到/usr/local/boost目录下，然后重新
## cmake并在后面的选项中加上选项 -DWITH_BOOST=/usr/local/boost
#############################################
cd /usr/local/src
tar xf $mysql_version.tar.gz
cd $mysql_version
cmake ./ -DCMAKE_INSTALL_PREFIX=$mysql_install_path -DMYSQL_DATADIR=$mysql_install_path/data -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/src/boost
make && make install

#添加用户和用户组
echo "正在添加用户和用户组******************"
groupadd mysql  
useradd mysql -g mysql -M -s /sbin/nologin
#增加一个名为CentOS Mysql的用户。
#-g：指定新用户所属的用户组(group)
#-M：不建立根目录
#-s：定义其使用的shell，/sbin/nologin代表用户不能登录系统。

#初始化数据库
echo "正在初始化数据库******************"
cd $mysql_install_path
chown -R mysql:mysql . #(为了安全安装完成后请修改权限给root用户)
scripts/mysql_install_db --user=mysql #(先进行这一步再做如下权限的修改)
chown -R root:mysql .  #(将权限设置给root用户，并设置给mysql组， 取消其他用户的读写执行权限，仅留给mysql "rx"读执行权限，其他用户无任何权限)
chown -R mysql:mysql ./data   #(给数据库存放目录设置成mysql用户mysql组，并赋予chmod -R ug+rwx  读写执行权限，其他用户权限一律删除仅给mysql用户权限)

#配置文件和启动脚本
echo "正在配置mysql******************"
cp support-files/my-default.cnf  /etc/my.cnf  #(并给/etc/my.cnf +x权限 同时删除 其他用户的写权限，仅仅留给root 和工作组 rx权限,其他一律删除连rx权限都删除)
#将mysql的启动服务添加到系统服务中  
cp support-files/mysql.server /etc/init.d/mysql
chmod +x /etc/init.d/mysql
#让mysql服务开机启动
chkconfig --add mysql
#启动mysql
service mysql start

#修改mysql root登录的密码(mysql必须先启动了才行哦)
cd $mysql_install_path
./bin/mysqladmin -u root password '123456'
#./bin/mysqladmin -u root -h web-mysql password '123456' #没执行成功。

#如mysql需要远程访问，还要配置防火墙开启3306端口
/etc/sysconfig/iptables
#/sbin/iptables -A INPUT m state --state NEW m tcp p dport 3306 j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
service iptables restart

#还要配置数据库中的用户权限，准许远程登录访问。
#删除密码为空的用户
#delete from user where password="";
#准许root用户远程登录
#update user set host = '%' where user = 'root';
#重启mysql生效
/etc/init.d/mysql restart

