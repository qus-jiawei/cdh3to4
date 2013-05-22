#!/bin/bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT


#clean profile
echo "删除软连接"
for node in $NODES
do
ssh -p $SSH_PORT $node "
rm -rf  ~/hadoop ~/hbase ~/hive ~/zookeeper ~/zookeeper_data ~/.hadoop_profile ~/.hbase_profile ~/.hive_profile ~/.zookeeper_profile
"
if [ "$1" == "clean" ];then
    ssh -p $SSH_PORT $node "rm -rf ~/hadoop_data"
    echo "clean hadoop_data on $node"
fi;
done

echo "连接软连接，分发环境配置"
for node in $NODES
do
    ssh -p $SSH_PORT $node "
        ln -s ~/$CDH3_HADOOP_DIR ~/hadoop;
        ln -s ~/$CDH3_HBASE_DIR ~/hbase;
    "
    scp -P $SSH_PORT $UP_CONF/cdh3_profile/hadoop_profile $node:~/.hadoop_profile
    scp -P $SSH_PORT $UP_CONF/cdh3_profile/hbase_profile $node:~/.hbase_profile
done
for node in $HIVE_NODES
do
    ssh -p $SSH_PORT $node "
        ln -s ~/$CDH3_HIVE_DIR ~/hive;
    "
    scp -P $SSH_PORT $UP_CONF/cdh3_profile/hive_profile $node:~/.hive_profile
done
for node in $ZK_NODES
do
    ssh -p $SSH_PORT $node "
        ln -s ~/$CDH3_ZK_DIR ~/zookeeper;
    "
    scp -P $SSH_PORT $UP_CONF/cdh3_profile/zookeeper_profile $node:~/.zookeeper_profile
done


sh $UP_BIN/config.sh cdh3
source ~/.bash_profile
hadoop namenode -format
echo "run source ~/.bash_profile"
#start-all.sh
#wait_for_safemode

#sh $UP_BIN/start-zk.sh 
#start-hbase.sh
