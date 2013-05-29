#!/usr/bin/env bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

var_die HIVE_MYSQL_HOST
var_die HIVE_MYSQL_PORT
var_die HIVE_MYSQL_USER
var_die HIVE_MYSQL_PASSWD
var_die HIVE_MYSQL_DATABASE

if [ "$HIVE_MYSQL" == "false" ];then
    echo "HIVE_MYSQL is false die!"
fi;

UP_7_8=$UP_DATA/hive_metastore/upgrade-0.7.0-to-0.8.0.mysql.sql
UP_8_9=$UP_DATA/hive_metastore/upgrade-0.8.0-to-0.9.0.mysql.sql
UP_9_10=$UP_DATA/hive_metastore/upgrade-0.9.0-to-0.10.0.mysql.sql
#debug use
UP_INIT_7=$UP_DATA/hive_metastore/hive-schema-0.7.0.mysql.sql


run_sql(){
    echo "running $1 to mysql:$HIVE_MYSQL_HOST $HIVE_MYSQL_PORT"
    echo "source $1" | mysql -h"${HIVE_MYSQL_HOST}" -P"${HIVE_MYSQL_PORT}" -u"${HIVE_MYSQL_USER}" -p"${HIVE_MYSQL_PASSWD}" -D"${HIVE_MYSQL_DATABASE}"
    echo "finish"
}

echo "connect to hive mysql and run sql"
#sql中使用了相对目录，所以需要跳进目录中
cd $UP_DATA/hive_metastore
run_sql $UP_7_8
run_sql $UP_8_9
run_sql $UP_9_10
cd $UP_ROOT

#更新mysql信息
metatool -listFSRoot 
sleep 5
for node in $HIVE_NODES
do
OLD_FS_ROOT=`xml_get "${UP_CONF_PICK}/hadoop/$node/core-site.xml" "fs.default.name"`
NEW_FS_ROOT=`xml_get ${UP_CONF_BUILD}/cdh4ha/hadoop/$node/core-site.xml "fs.defaultFS"`
break;
done
echo "OLD_FS_ROOT is $OLD_FS_ROOT . NEW_FS_ROOT is $NEW_FS_ROOT"
metatool -updateLocation $NEW_FS_ROOT $OLD_FS_ROOT -tablePropKey avro.schema.url  -serdePropKey schema.url  
sleep 5
metatool -listFSRoot
sleep 5

sh $UP_BIN/hive_check.sh
