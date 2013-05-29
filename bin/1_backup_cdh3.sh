#!/usr/bin/env bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

echo "close hbase hive zookeeper first".
sh $UP_BIN/start_close_check.sh hbase close
sh $UP_BIN/start_close_check.sh zk close
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
sh $UP_BIN/start_close_check.sh dfs

sleep 3
echo "back up name dir to $UP_BACKUP/$BACKUP_TAR"
cd `dirname $NAME_DIR`
tar -zcf $UP_BACKUP/$BACKUP_TAR name
ls -l $UP_BACKUP

if [ "$HIVE_MYSQL" == "false"];then
    echo "skip backup mysql"
else
    
    echo "dump mysql ..."
    mysqldump -h"${HIVE_MYSQL_HOST}" -P"${HIVE_MYSQL_PORT}" -u"${HIVE_MYSQL_USER}" -p"${HIVE_MYSQL_PASSWD}" "${HIVE_MYSQL_DATABASE}" >> $UP_BACKUP/hive_mysql_dump_${TIME_VERSION}

fi;

