#!/bin/bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh

var_die UP_ROOT

echo "${ZK_CONF_DIR}"

CONF=${UP_CONF_TEMP}/cdh3

for node in $NODES
do
myscp "$CONF/hadoop/*" "$node:${CDH3_CONF_DIR}"
myscp "$CONF/hbase/*" "$node:${HBASE_CONF_DIR}" 
done


for node in $HIVE_NODES
do
myscp "$CONF/hive/*" "$node:${HIVE_CONF_DIR}"
done


for node in $ZK_NODES
do
myscp  "$CONF/zk/*" "$node:${ZK_CONF_DIR}"
done
