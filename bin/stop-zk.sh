#!/bin/bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

for node in $ZK_NODES
do
    echo "start zk in $node ..."
    ssh -p $SSH_PORT $node "sh ~/zookeeper/bin/zkServer.sh stop"

done

