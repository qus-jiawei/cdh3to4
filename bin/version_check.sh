#!/bin/bash

UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

echo "***获取现在安装的版本*****"

#检查远端的机器的版本信息
#$1 机器名字 $2 运行的命令 $3 keyword
#检查成功返回 true 否则返回 false
check_version(){
    result=`ssh -p $SSH_PORT $1 $2`
    check=`echo $result|grep $3`
    if [ -z "$check" ] ;then 
        die "$1's $2 check result is : $result . Don't match version cdh4.2.1.";
    fi;

}

i=0
for node in $NODES
do
echo $node
check_version $node "ls -ld ~/hadoop" "$CDH4_HADOOP_DIR"
check_version $node "grep HADOOP_PROFILE ~/.hadoop_profile" "CDH4.2.1"
check_version $node "ls -ld ~/hbase" "$CDH4_HBASE_DIR"
check_version $node "grep HBASE_PROFILE ~/.hbase_profile" "CDH4.2.1"
echo "$node hadoop hbase version check is fine"
done

for node in $HIVE_NODES
do
echo $node
check_version $node "ls -ld ~/hive" "$CDH4_HIVE_DIR"
check_version $node "grep HIVE_PROFILE ~/.hive_profile" "CDH4.2.1"
echo "$node hive version check is fine"
done

for node in $ZK_NODES
do
echo $node
check_version $node "ls -ld ~/zookeeper" "$CDH4_ZK_DIR"
check_version $node "grep ZOOKEEPER_PROFILE ~/.zookeeper_profile" "CDH4.2.1"
echo "$node zookeeper version check is fine"
done


