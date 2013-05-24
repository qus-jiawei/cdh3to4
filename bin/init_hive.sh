#!/usr/bin/env bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

var_die HIVE_MYSQL_HOST
var_die HIVE_MYSQL_PORT
var_die HIVE_MYSQL_USER
var_die HIVE_MYSQL_PASSWD
var_die HIVE_MYSQL_DATABASE

#debug use
UP_INIT_7=$UP_DATA/hive_metastore/hive-schema-0.7.0.mysql.sql


run_sql(){
    echo "running $1 to mysql:$HIVE_MYSQL_HOST $HIVE_MYSQL_PORT"
    echo "source $1" | mysql -h"${HIVE_MYSQL_HOST}" -P"${HIVE_MYSQL_PORT}" -u"${HIVE_MYSQL_USER}" -p"${HIVE_MYSQL_PASSWD}" -D"${HIVE_MYSQL_DATABASE}"
#echo " -h\"${HIVE_MYSQL_HOST}\" -P\"${HIVE_MYSQL_PORT}\" -u\"${HIVE_MYSQL_USER}\" -p\"${HIVE_MYSQL_PASSWD}\" -D\"${HIVE_MYSQL_DATABASE}\" "
    echo "finish"
}

clean_sql(){
    echo "drop database ${HIVE_MYSQL_DATABASE}" | mysql -h"${HIVE_MYSQL_HOST}" -P"${HIVE_MYSQL_PORT}" -u"${HIVE_MYSQL_USER}" -p"${HIVE_MYSQL_PASSWD}"
    echo "create database ${HIVE_MYSQL_DATABASE}" | mysql -h"${HIVE_MYSQL_HOST}" -P"${HIVE_MYSQL_PORT}" -u"${HIVE_MYSQL_USER}" -p"${HIVE_MYSQL_PASSWD}"
}
echo "connect to hive mysql and run sql"
#sql中使用了相对目录，所以需要跳进目录中
cd $UP_DATA/hive_metastore
clean_sql
run_sql $UP_INIT_7
cd $UP_ROOT

