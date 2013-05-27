#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09

#$1 要修改的hadoop目录 下面是层级的host目录
HADOOP_DIR=$1
#############helper function define################
#遍历host数组和目录数组输出可操作的private修改格式队列
#$1 hosts  $2 conf name  $3 dirs $4 file name
build_conf(){
    hosts=$1
    conf_name=$2
    dirs=$3
    file_name=$4

    value="";
    for dir in $dirs
    do
        value="$value$dir,"
    done
    value=${value#,}

    for host in $hosts
    do
        echo "$file_name#$host#$conf_name#$value";
    done
}

#############helper function define end ################


#按照格式 filename#hostname#配置项key#配置项value 方式输出，以#划分
#一个配置一行
pc=`. $UP_CONF/private_config.sh`

for line in $pc;
do
    file_name=`echo $line|awk '{split($0,a,"#");print a[1];}'`
    host_name=`echo $line|awk '{split($0,a,"#");print a[2];}'`
    conf_name=`echo $line|awk '{split($0,a,"#");print a[3];}'`
    value_name=`echo $line|awk '{split($0,a,"#");print a[4];}'`
    xml_set "$HADOOP_DIR/$host_name/${file_name}" $conf_name $value_name
done

