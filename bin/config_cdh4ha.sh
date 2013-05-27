#!/bin/bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh

var_die UP_ROOT

echo "${ZK_CONF_DIR}"

CONF=${UP_CONF_BUILD}/cdh4ha/

for node in $NODES
do
myscp "$CONF/hadoop/$node/*" "$node:${CDH4_CONF_DIR}"
myscp "$CONF/hbase/$node/*" "$node:${CDH4_HBASE_DIR}/conf" 
done


for node in $HIVE_NODES
do
myscp "$CONF/hive/$node/*" "$node:${CDH4_HIVE_DIR}/conf"
done


for node in $ZK_NODES
do
myscp  "$CONF/zk/$node/zoo.cfg" "$node:${CDH4_ZK_DIR}/conf/"
myscp  "$CONF/zk/$node/myid" "$node:${CDH4_ZK_DIR}/data/"
done
