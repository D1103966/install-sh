#!/bin/bash
if [ `ls|grep gawk` == "" ]
then 
	wget http://ftp.gnu.org/gnu/gawk/gawk-4.1.1.tar.gz
fi
tar -zxvf gawk-4.1.1.tar.gz
cd gawk-4.1.1
./configure --prefix=/usr/local/lib/gawk-4.1.1
make
make check
make install
if [[ `cat /etc/profile|grep '/usr/local/lib/gawk-4.1.1/bin'` = "" ]]
then
	echo 'export PATH=/usr/local/lib/gawk-4.1.1/bin:$PATH' >> /etc/profile
fi
source /etc/profile
cd ..
rm -rf gawk-4.1.1
