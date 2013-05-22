#!/bin/bash

UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

for node in $ZK_NODES
do
    ssh -p $SSH_PORT $node '
    
    clientPort=`grep client ~/zookeeper/conf/zoo.cfg`
    port=${clientPort:11}

    echo "
    ls /
    " |sh ~/zookeeper/bin/zkCli.sh -server ${node}:${port}
    
    '

done
