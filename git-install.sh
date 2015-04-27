#!/bin/bash
yum -y install gcc gcc-c++ curl curl-devel zlib-devel openssl-devel perl cpio expat-devel gettext-devel perl-ExtUtils-MakeMaker tcl libcurl-devel  #安装依赖
if [ `ls|grep git` = "" ]
then 
	wget https://www.kernel.org/pub/software/scm/git/git-2.3.6.tar.gz
fi
tar -zxvf git-2.3.6.tar.gz
cd git-2.3.6
./configure --prefix=/usr/local/lib/git-2.3.6
make
make install
if [ `cat /etc/profile | grep 'PATH=/usr/local/lib/git-2.3.6/bin'` = "" ]
then
	echo 'export PATH=/usr/local/lib/git-2.3.6/bin:$PATH' >> /etc/profile
fi
source /etc/profile
cd ..
rm -rf git-2.3.6
