#!/bin/bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh

var_die UP_ROOT

echo "${ZK_CONF_DIR}"

CONF=${UP_CONF_TEMP}/cdh3

for node in $NODES
do
myscp "$CONF/hadoop/*" "$node:${CDH3_CONF_DIR}"
myscp "$CONF/hbase/*" "$node:${CDH3_HBASE_DIR}/conf" 
done


for node in $HIVE_NODES
do
myscp "$CONF/hive/*" "$node:${CDH3_HIVE_DIR}/conf"
done

cp $CONF/zk/zoo.cfg /tmp/zoo.cfg
sed -i "s/qiujw/$USER_NAME/" /tmp/zoo.cfg
for node in $ZK_NODES
do
myscp  "/tmp/zoo.cfg" "$node:${CDH3_ZK_DIR}/conf"
done
