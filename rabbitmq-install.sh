#!/bin/bash
#需要先安装erlang
yum -y install libxslt unzip xmlto
if [[ `ls|grep rabbitmq` == "" ]]
then 
	wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.5.3/rabbitmq-server-3.5.3.tar.gz
fi
tar -zxvf rabbitmq-server-3.5.3.tar.gz
cd rabbitmq-server-3.5.3/
make
make TARGET_DIR=/usr/local/rabbitmq SBIN_DIR=/usr/local/rabbitmq/sbin MAN_DIR=/usr/local/rabbitmq/man install  
cd .. 
yum -y install python-setuptools
easy_install pip        #这个需要外网ip
pip install pika
