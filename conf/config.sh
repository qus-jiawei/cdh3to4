#!/bin/bash

NODES="
platform30
platform31
platform32
platform33
platform34
"
#以下部分不影响配置文件生成
#仅影响包分发
HADOOP_NODES="
platform30
platform31
platform32
platform33
platform34
"
NAME_NODES="
platform30
platform31
"

STANDBY_NODE=platform31

DATA_NODES="
platform31
platform32
platform33
platform34
"
QJOURNAL_NODES="
platform32
platform33
platform34
"
RM="platform30"


HBASE_NODES="
platform30
platform31
platform33
platform34
"
BACKUP_NODES="
platform31
"
RS_NODES="
platform33
platform34
"

#默认第1,2台
HIVE_NODES="
platform30
platform31
platform32
"
#默认前5台
ZK_NODES="
platform33
platform34
platform32
"
SSH_PORT=9922

PORT_PREFIX=57

#如果为空，将会尝试从hive-site.xml中获得,使用匹配方式获取，不保证一定获取正确
#推荐手动指定
HIVE_MYSQL_HOST="platform30"
HIVE_MYSQL_PORT="58306"
HIVE_MYSQL_USER="hive"
HIVE_MYSQL_PASSWD="hive"
HIVE_MYSQL_DATABASE="qiujw_hive_metastore"

#HIVE_MYSQL_HOST="platform33"
#HIVE_MYSQL_PORT="3306"
#HIVE_MYSQL_USER="qiujw"
#HIVE_MYSQL_PASSWD="ucbigdata"
#HIVE_MYSQL_DATABASE="hive"

#name dir
NAME_DIR=~/hadoop_data/dfs/name
#一般都不需要改部分啊啊啊-----------

BACKUP_TAR=name-backup-`date +%Y%m%d`.tar.gz
UPGRADE_TAR=name-upgrade-`date +%Y%m%d`.tar.gz

#是否强制重新解压JAR包
FORCE_UNTAR="false"



#以下不用改啊啊啊啊----------------------------------------
NS=($NODES)
echo $HIVE_NODES
if [ -z "$HADOOP_NODES" ]; then
    HADOOP_NODES=$NODES
fi

if [ -z "$NAME_NODES" ]; then
    HAME_NODES=${NS[@]:0:2}
fi
if [ -z "$DATA_NODES" ]; then
    DATA_NODES=$NODES
fi
if [ -z "$QJOURNAL_NODES" ]; then
    QJOURNAL_NODES=$NODES
fi
if [ -z "$RM" ]; then
    RM=${NS[@]:0:1}
fi

if [ -z "$HBASE_NODES" ]; then
    HBASE_NODES=$NODES
fi
if [ -z "$BACKUP_NODES" ]; then
    BACKUP_NODES=${NS[@]:1:1}
fi
if [ -z "$RS_NODES" ]; then
    RS_NODES=${NS[@]:2:3}
fi


if [ -z "$HIVE_NODES" ]; then
    HIVE_NODES=${NS[@]:0:2}
fi

if [ -z "$ZK_NODES" ]; then
    ZK_NODES=${NS[@]:0:5}
fi


