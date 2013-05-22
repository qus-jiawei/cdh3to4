#!/bin/bash

UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

echo "***清楚所有的安装*****"
#stop-all.sh
#stop-hbase.sh
sh $UP_BIN/close_check.sh hbase
sh $UP_BIN/close_check.sh hadoop

i=0
for node in $NODES
do
echo $node
 ssh -p $SSH_PORT $node rm -rf ~/.deployer_profile ~/hadoop ~/.hadoop_profile ~/hbase ~/.hbase_profile ~/hive ~/.hive_profile
 ssh -p $SSH_PORT $node rm -rf ~/hadoop_data
done

