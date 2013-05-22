#!/bin/bash

UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

source ~/.bash_profile
##屏蔽了自动创建SSH
#unset DEPLOYER_HOME
#rm ~/hadoop-deployer/cdh3/logs/*
#fork sh ~/hadoop-deployer/cdh3/install_hadoop.sh
#sh ~/hadoop-deployer/cdh3/install_hbase.sh
#sh ~/hadoop-deployer/cdh3/install_hive.sh
#-------------------
echo "先手动装安装,(貌似外部调用depoloer有BUG) "
echo "安装完可以运行sh $UP_BIN/version_check.sh检查"
exit

sh $UP_BIN/config.sh cdh3
hadoop namenode -format
start-all.sh
start-hbase.sh

