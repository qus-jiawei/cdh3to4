#!/usr/bin/env bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

echo "close hbase hive zookeeper first".
sh $UP_BIN/close_check.sh hbase
sh $UP_BIN/close_check.sh zk
#sh $UP_BIN/close_check.sh hive

echo "enter safemode ..."
hadoop dfsadmin -safemode enter > /dev/null 2>&1
sleep 3

echo "saveNamespace  ..."
hadoop dfsadmin -saveNamespace > /dev/null 2>&1
sleep 3

echo "stop cdh3 ..."
stop-all.sh
sleep 5
sh $UP_BIN/close_check.sh hadoop

sleep 3
echo "back up name dir to $UP_BACKUP/$BACKUP_TAR"
cd `dirname $NAME_DIR`
tar -zcf $UP_BACKUP/$BACKUP_TAR name
ls -l $UP_BACKUP

#/home/zhaigy1/pkg/fuse-dfs
