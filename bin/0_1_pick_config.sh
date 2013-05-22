#!/bin/bash

UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT


#从各个机器上采集到旧版hadoop配置文件
for node in $NODES
do
mkdir -p ${UP_CONF_PICK}/hadoop/$node
echo "pick $node";
scp $node:${HADOOP_CONF_DIR}/* ${UP_CONF_PICK}/hadoop/$node/ >>/dev/null
done

