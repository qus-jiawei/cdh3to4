#!/bin/bash

UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh

var_die UP_ROOT
if [ -z "$1" ]; then 
    echo "unknow check point"
    die;
fi;

echo "starting checking $1 ..."

if [ "$1" == "hbase" ]; then 
    word="HMaster|HRegionServer"
fi;
if [ "$1" == "hadoop" ]; then
    word="DataNode|NameNode"
fi;
if [ "$1" == "zk" ]; then
    word="QuorumPeerMain"
fi;
if [ "$1" == "jn" ]; then
    word="JournalNode"
fi;
if [ "$1" == "all" ]; then
    word="*"
fi;

check_ok="false"
while [ "$check_ok" != "true" ];
do
check_ok="true"
i=0
for node in $NODES
do
    result=`ssh -p $SSH_PORT $node jps|egrep "$word"` 
    if [ -z "$result"  ]; then 
        echo "$node is down";
        check_ok="false"
    else 
        echo "$node is up:***********"
        echo "$result" 
    fi;

i=`expr $i + 1`
done
if [ "$check_ok" == "true" ]; then 
    echo "checking $1 finish"
    break;
else
    echo "$1 is not start!!!! check is not ok and sleep 1";
    sleep 1
    if [ "$1" == "all" ]; then exit;fi;
fi;

done
