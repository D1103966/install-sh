#!/bin/bash
# 需要sudo执行

dir=`pwd`

#要安装pcre先要安装gcc, g++
if [[ `ls /etc|grep redhat-release` != "" ]]
then
	yum -y install gcc gcc-c++
elif [[ `ls /etc|grep debian_version` != "" ]]
then
	apt-get -y install gcc gcc-c++
fi

if [[ `ls|grep apr` == "" ]]
then
	wget http://mirrors.cnnic.cn/apache//apr/apr-1.5.2.tar.gz
fi
tar -zxvf apr-1.5.2.tar.gz
mkdir /usr/local/lib/apr-1.5.2
cd $dir/apr-1.5.2
./configure --prefix=/usr/local/lib/apr-1.5.2 
make
make install

cd $dir
if [[ `ls|grep apr-util` == "" ]]
then
	wget http://mirrors.cnnic.cn/apache//apr/apr-util-1.5.4.tar.gz
fi
tar -zxvf apr-util-1.5.4.tar.gz
mkdir /usr/local/lib/apr-util-1.5.4.tar.gz
cd $dir/apr-util-1.5.4
./configure --prefix=/usr/local/lib/apr-util-1.5.4 --with-apr=/usr/local/lib/apr-1.5.2
make 
make install

cd $dir
if [[ `ls|grep pcre` == "" ]]
then
	wget http://ncu.dl.sourceforge.net/project/pcre/pcre/8.37/pcre-8.37.tar.gz
fi
tar -zxvf pcre-8.37.tar.gz
mkdir /usr/local/lib/pcre-8.37
cd $dir/pcre-8.37
./configure --prefix=/usr/local/lib/pcre-8.37
make 
make install

cd $dir
if [[ `ls|grep httpd` == "" ]]
then
	wget http://www.apache.org/dist/httpd/httpd-2.4.12.tar.gz
fi
tar -zxvf httpd-2.4.12.tar.gz
mkdir /usr/local/lib/httpd-2.4.12
cd $dir/httpd-2.4.12
./configure --prefix=/usr/local/lib/httpd-2.4.12 --with-apr=/usr/local/lib/apr-1.5.2  --with-apr-util=/usr/local/lib/apr-util-1.5.4 --with-pcre=/usr/local/lib/pcre-8.37  --enable-so
make
make install

#解决httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message

sed -i 's/^#ServerName www.example.com:80/ServerName localhost/g' /usr/local/lib/httpd-2.4.12/conf/httpd.conf

/usr/local/lib/httpd-2.4.12/bin/apachectl start                          #启动apache
if [[ `curl localhost:80' == "<html><body><h1>It works!</h1></body></html>" ]]
then
	echo "----------------------安装成功-------------------------------------"
	cd $dir
	rm -rf apr-1.5.2/ apr-util-1.5.4/ pcre-8.37/ httpd-2.4.12/
fi
