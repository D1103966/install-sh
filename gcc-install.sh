#!/bin/bash
if [[ `ls|grep gcc` = "" ]]
then
	wget http://ftp.gnu.org/gnu/gcc/gcc-5.1.0/gcc-5.1.0.tar.gz
fi
tar -zxvf gcc-5.1.0.tar.gz
mkdir gcc-build
cd gcc-build
rm -rf *
../gcc-5.1.0/contrib/download_prerequisites
../gcc-5.1.0/configure --build=x86_64-linux-gnu --prefix=/usr/local/lib/gcc-5.1.0 --enable-checking=release --enable-languages=c,c++,fortran --disable-multilib
make
make install
if [[ `cat /etc/profile | grep 'PATH=/usr/local/lib/gcc-5.1.0/bin'` = "" ]]
then
	echo 'export PATH=/usr/local/lib/gcc-5.1.0/bin:$PATH' >> /etc/profile
fi
source /etc/profile
cd ..
rm -rf gcc-5.1.0 gcc-build
