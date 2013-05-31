#!/bin/bash

UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

#从各个机器上采集到hadoop的配置文件
#并和hadoop的cdh4HA版本结合，生成非HA版本的配置文件
#将旧版的特殊配置提出来作为private xml
#校验cdh4HA版本的配置文件是否满足基本的校验规则
 
build_cdh4(){
    for node in $NODES
    do
        echo "build cdh4 for $node";
        mkdir -p ${UP_CONF_BUILD}/cdh4/hadoop/$node
        cp ${UP_CONF_TEMP}/cdh4ha/hadoop/* ${UP_CONF_BUILD}/cdh4/hadoop/$node/
#用hadoop_conf.sh修改配置
        . $UP_BIN/support/hadoop_conf.sh  ${UP_CONF_BUILD}/cdh4/hadoop/$node/
        if [ -d "${UP_CONF_PICK}/hadoop/$node" ];then
            cp ${UP_CONF_PICK}/hadoop/$node/core-site.xml ${UP_CONF_BUILD}/cdh4/hadoop/$node/
            cp ${UP_CONF_PICK}/hadoop/$node/hdfs-site.xml ${UP_CONF_BUILD}/cdh4/hadoop/$node/
            cp ${UP_CONF_PICK}/hadoop/$node/mapred-site.xml ${UP_CONF_BUILD}/cdh4/hadoop/$node/
        else
            echo "not find ${UP_CONF_PICK}/hadoop/$node"
        fi;
    done
}

build_cdh4ha(){
    for node in $NODES
    do
        echo "build cdh4ha for $node";
        mkdir -p ${UP_CONF_BUILD}/cdh4ha/hadoop/$node
        mkdir -p ${UP_CONF_BUILD}/cdh4ha/hbase/$node/
        cp ${UP_CONF_TEMP}/cdh4ha/hadoop/* ${UP_CONF_BUILD}/cdh4ha/hadoop/$node/
#调用hadoop_conf.sh修改配置
        . $UP_BIN/support/hadoop_conf.sh  ${UP_CONF_BUILD}/cdh4ha/hadoop/$node/

       cp ${UP_CONF_TEMP}/cdh4ha/hbase/* ${UP_CONF_BUILD}/cdh4ha/hbase/$node/
#调用hbase_conf.sh修改配置
        . $UP_BIN/support/hbase_conf.sh "${UP_CONF_BUILD}/cdh4ha/hbase/$node/" 

    done
#调用private_conf.sh修改private配置        
    . $UP_BIN/support/private_conf.sh ${UP_CONF_BUILD}/cdh4ha/hadoop


    for node in $HIVE_NODES
    do
        mkdir -p ${UP_CONF_BUILD}/cdh4ha/hive/$node/
        cp ${UP_CONF_TEMP}/cdh4ha/hive/* ${UP_CONF_BUILD}/cdh4ha/hive/$node/
#调用hive_conf.sh修改配置        
        . $UP_BIN/support/hive_conf.sh "${UP_CONF_BUILD}/cdh4ha/hive/$node/"
    done

    build_zk_config 

}
#生成zoo.cfg和myid文件
build_zk_config(){
    build_zk_file="${UP_CONF_BUILD}/cdh4ha/zoo.cfg"
    cp ${UP_CONF_TEMP}/cdh4ha/zk/zoo.cfg $build_zk_file

    sed  "s#USER_HOME#${HOME}#g" -i $build_zk_file
    sed  "s#PP#${PORT_PREFIX}#g" -i $build_zk_file

    peerport=` grep peerport $build_zk_file |awk -F '=' '{print $2}'`
    leaderport=` grep leaderport $build_zk_file|awk -F '=' '{print $2}'`
    id=1
    for node in $ZK_NODES
    do
        echo "server.$id=$node:$peerport:$leaderport" >> $build_zk_file
        id=`expr $id + 1`
    done

    id=1
    for node in $ZK_NODES
    do
        mkdir -p ${UP_CONF_BUILD}/cdh4ha/zk/$node
        echo "$id" > ${UP_CONF_BUILD}/cdh4ha/zk/$node/myid
        id=`expr $id + 1`
        cp $build_zk_file ${UP_CONF_BUILD}/cdh4ha/zk/$node/
    done
}

#清空build目录
rm -rf ${UP_CONF_BUILD}
mkdir -p ${UP_CONF_BUILD}


#hadoop的cdh4HA版本结合，生成非HA版本的配置文件
#echo "注释掉CDH4的生成部分用于测试"
build_cdh4

#生成cdh4ha配置
#将旧版的特殊配置提出来作为private xml

build_cdh4ha



#验cdh4HA版本的配置文件是否满足基本的校验规则
#
