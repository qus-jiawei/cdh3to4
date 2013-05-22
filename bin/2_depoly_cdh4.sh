#!/bin/bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT


#clean profile
echo "删除软连接"
for node in $NODES
do
ssh -p $SSH_PORT $node "
rm -rf  ~/hadoop ~/hbase ~/hive ~/zookeeper ~/.hadoop_profile ~/.hbase_profile ~/.hive_profile ~/.zookeeper_profile
"
done

echo "连接软连接，分发环境配置"
for node in $NODES
do
    ssh -p $SSH_PORT $node "
        ln -s ~/$CDH4_HADOOP_DIR ~/hadoop;
        ln -s ~/$CDH4_HBASE_DIR ~/hbase;
    "
    scp -P $SSH_PORT $UP_CONF/cdh4_profile/hadoop_profile $node:~/.hadoop_profile
    scp -P $SSH_PORT $UP_CONF/cdh4_profile/hbase_profile $node:~/.hbase_profile
done
for node in $HIVE_NODES
do
    ssh -p $SSH_PORT $node "
        ln -s ~/$CDH4_HIVE_DIR ~/hive;
    "
    scp -P $SSH_PORT $UP_CONF/cdh4_profile/hive_profile $node:~/.hive_profile
done
for node in $ZK_NODES
do
    ssh -p $SSH_PORT $node "
        ln -s ~/$CDH4_ZK_DIR ~/zookeeper;
    "
    scp -P $SSH_PORT $UP_CONF/cdh4_profile/zookeeper_profile $node:~/.zookeeper_profile
done

sh $UP_BIN/config_cdh4.sh

#加入检查TODO...
sh $UP_BIN/version_check.sh

