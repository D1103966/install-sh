#!/bin/bash

#安装erlang语言需要先安装jdk
yum -y install build-essential libncurses5-dev ncurses-devel  libssl-dev m4 unixodbc unixodbc-dev freeglut3-dev libwxgtk2.8-dev xsltproc fop tk make gcc gcc-c++ kernel-devel openssl-devel

yum -y install python python-setuptools

if [[ `ls|grep git` == "" ]]
then
	wget http://www.erlang.org/download/otp_src_17.tar.gz 
fi
tar -zxvf otp_src_17.tar.gz
cd otp_src_17.0
./configure --prefix=/usr/local/erlang --with-ssl --enable-threads --enable-smp-support --enable-kernel-poll --enable-hipe --without-javac  
make 
make install
if [[ `cat /etc/profile | grep '/usr/local/erlang'` = "" ]]
then
	echo 'export ERL_HOME=/usr/local/erlang' >> /etc/profile
	echo 'export PATH=$ERL_HOME/bin:$PATH' >> /etc/profile  #这里使用单引号，避免将$PATH转换了
fi
source /etc/profile
cd .. 
rm -rf opt_src_17.0
