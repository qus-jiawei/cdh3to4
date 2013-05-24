#!/bin/bash

UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh

var_die UP_ROOT

i=1
for node in $ZK_NODES
do
echo $node
ssh -p $SSH_PORT $node "mkdir -p ~/zookeeper_data/logs;echo '$i' > ~/zookeeper_data/myid"
#ssh -p $SSH_PORT $node sh ~/zookeeper/bin/zkServer-initialize.sh --myid=$i --force
#ssh -p $SSH_PORT $node mkdir -p ~/zookeeper_data/logs
ssh -p $SSH_PORT $node sh ~/zookeeper/bin/zkServer.sh start
i=`expr $i + 1`

done

#start-all.sh
