#!/bin/bash
# 需要sudo执行

dir=`pwd`

if [[ `ls|grep apr` = "" ]]
then
	wget http://mirrors.cnnic.cn/apache//apr/apr-1.5.2.tar.gz
fi
tar -zxvf apr-1.5.2.tar.gz
mkdir /usr/local/lib/apr-1.5.2
cd $(dir)/apr-1.5.2
./configure --prefix=/usr/local/lib/apr-1.5.2 
make
make install

cd $(dir)
if [[ `ls|grep apr-util` = "" ]]
then
	wget http://mirrors.cnnic.cn/apache//apr/apr-util-1.5.4.tar.gz
fi
tar -zxvf apr-util-1.5.4.tar.gz
mkdir /usr/local/lib/apr-util-1.5.4.tar.gz
cd $(dir)/apr-util-1.5.4
./configure --prefix=/usr/local/lib/apr-util-1.5.4 --with-apr=/usr/local/lib/apr-1.5.2
make 
make install

cd $(dir)
if [[ `ls|grep httpd` = "" ]]
then
	wget http://mirrors.hust.edu.cn/apache//httpd/httpd-2.4.12.tar.bz2
fi
tar -zxvf httpd-2.4.12.tar.bz2
mkdir /usr/local/lib/httpd-2.4.12
cd $(dir)/httpd-2.4.12
./configure --prefix=/usr/local/lib/httpd-2.4.12 --with-apr=/usr/local/lib/apr-1.5.2  --with-apr-util=/usr/local/lib/apr-util-1.5.4  --enable-so
make
make install

cd $(dir)
rm -rf apr-1.5.2/ apr-util-1.5.4/ httpd-2.4.12/
