#!/bin/bash

UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh

var_die UP_ROOT

i=0
for node in $NODES
do
echo $node
#scp -P $SSH_PORT $UP_CONF/cdh3/zoo.cfg  $node:~/zookeeper/conf/
#ssh -p $SSH_PORT $node mkdir -p ~/zookeeper_data
#ssh -p $SSH_PORT $node mkdir -p ~/zookeeper_data/logs
#ssh -p $SSH_PORT $node sh ~/zookeeper/bin/zkServer-initialize.sh --myid=$i --force
#ssh -p $SSH_PORT $node sh ~/zookeeper/bin/zkServer.sh start
#ssh -p $SSH_PORT $node "rm -rf /home/zhaigy1/hadoop/etc/hadoop/*"
scp -P $SSH_PORT /home/qiujw/cdh3to4/conf/template/cdh3/hadoop/* $node:~/hadoop/conf
#ssh -p $SSH_PORT $node tar -zxvf  ~/zookeeper-3.4.5-cdh4.2.1.tar.gz
#ssh -p $SSH_PORT $node mkdir -p zookeeper/data/
#ssh -p $SSH_PORT $node echo "$i" > $node:~/zookeeper/data/myid
#ssh -p $SSH_PORT $node cat ~/zookeeper/data/myid
#scp -P $SSH_PORT ~/hadoop-2.0.0-cdh4.2.1.tar.gz $node:~/
#ssh -p $SSH_PORT $node tar -zxvf ~/hadoop-2.0.0-cdh4.2.1.tar.gz
#scp -P $SSH_PORT ~/hbase-0.94.2-cdh4.2.1.tar.gz $node:~/
# ssh -p $SSH_PORT $node tar -zxvf  ~/hbase-0.94.2-cdh4.2.1.tar.gz
#scp -P $SSH_PORT ~/hive-0.10.0-cdh4.2.1.tar.gz $node:~/
# ssh -p $SSH_PORT $node tar -zxvf  ~/hive-0.10.0-cdh4.2.1.tar.gz
i=`expr $i + 1`

done
