#!/bin/bash

UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh

var_die UP_ROOT
if [ -z "$1" ]; then 
    echo "unknow check point"
    die;
fi;
check_point=$1

if [ "$2" == "start" ]; then
    echo "starting checking $check_point ..."
    echo ""
    fun="$2"
else
    echo "closeing checking $check_point ..."
    echo ""
    fun="$2" 
fi;


##############################
#function define
#$word $check_nodes
start_check(){
    echo $word $check_nodes
    check_ok="false"
    while [ "$check_ok" != "true" ];
    do
    check_ok="true"
    i=0
    for node in $check_nodes
    do
        result=`ssh -p $SSH_PORT $node jps|egrep "$word"` 
        if [ -z "$result"  ]; then 
            echo "$node _____ down"
            check_ok="false"
        else 
            echo "$node ||||| up "
            echo "$result" 
        fi;
    
    i=`expr $i + 1`
    done
    if [ "$check_ok" == "true" ]; then 
        echo "checking $1 finish **********"
        echo ""
        break;
    else
        echo "$check_point is not start!!!! check is not ok";
        sleep 1
        if [ "$1" == "all" ]; then exit;fi;
    fi;
    
    done
}

close_check(){
    check_ok="false"
    while [ "$check_ok" != "true" ];
    do
    check_ok="true"
    i=0
    for node in $check_nodes
    do
        result=`ssh -p $SSH_PORT $node jps|egrep "$word"` 
        if [ -z "$result"  ]; then 
            echo "$node _____ down";
        else 
            echo "$node ||||| up "
            echo "$result" 
            check_ok="false"
        fi;
    
    i=`expr $i + 1`
    done
    if [ "$check_ok" == "true" ]; then 
        echo "checking $1 finish **********"
        break;
    else
        echo "$check_point is not close!!!! check is not ok";
        sleep 1
        if [ "$1" == "all" ]; then exit;fi;
    fi;
    
    done
}

check(){
    if [ "$fun" == "start" ];then
        start_check;
    else
        close_check;
    fi;
}

get_data_node(){
    cat ${HADOOP_CONF_DIR}/slaves
}
#TODO BUG
get_name_node(){
    if [ -f "${HADOOP_BIN}/hdfs" ];then 
        hdfs getconf -namenodes
    else
        hostname
    fi;
}
get_hmaster_node(){
    echo $START_HMASTER;
    cat ${HBASE_CONF_DIR}/backup-masters 
}
get_region_node(){
    cat ${HBASE_CONF_DIR}/regionservers
}

#############################




##################################
if [ "$1" == "hbase" ]; then 
    check_nodes=`get_hmaster_node`
    word="HMaster"
    check
    check_nodes=`get_region_node`
    word="HRegionServer"
    check
fi;
if [ "$1" == "dfs" ]; then
    check_nodes=`get_name_node`
    word="NameNode"
    check
    check_nodes=`get_data_node`
    word="DataNode"
    check

fi;

if [ "$1" == "zk" ]; then
    check_nodes=$ZK_NODES
    word="QuorumPeerMain"
    check
fi;
if [ "$1" == "jn" ]; then
    check_nodes=$QJOURNAL_NODES
    word="JournalNode"
    check
fi;
if [ "$1" == "all" ]; then
    check_nodes=$NODES
    word="*"
    check
fi;




