#!/bin/sh

#安装bison
echo "正在安装bison******************"
cd /root/download/
tar xf bison-3.0.tar.gz
cd bison-3.0
./configure 
make && make install
echo "bison安装成功******************"

#安装ncurses
echo "*********************************"
echo "*********************************"
echo "正在安装ncurses******************"
echo "*********************************"
echo "*********************************"
cd /root/download/
tar xf ncurses-5.8.tar.gz
cd ncurses-5.8
./configure 
make && make install
echo "ncurses安装成功******************"

#安装CMAKE
echo "CMAKE安装成功******************"
cd /root/download/
tar xf cmake-2.8.12.2.tar.gz
cd cmake-2.8.12.2
./configure 
gmake && make install

#安装mysql
echo "正在安装mysql******************"
cd /root/download/
tar xf mysql-5.6.17.tar.gz
cd mysql-5.6.17
cmake ./ -DWITHOUT_SERVER=ON -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -Wno-dev
make && make install
echo "bison安装成功******************"

#安装mysql扩展
echo "正在安装php-mysql扩展******************"
cd /usr/local/src/php-5.4.25/ext/mysql/
/usr/local/php-5.4.25/bin/phpize 
./configure --with-php-config=/usr/local/php-5.4.25/bin/php-config --with-mysql=/usr/local/mysql
make && make install
echo "php-mysql扩展安装成功******************"
echo "请手动修改php.ini配置文件，加载mysql.so，重启php-fpm"