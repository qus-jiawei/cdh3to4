#!/bin/bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

source ~/.bash_profile

start-dfs.sh -upgrade

sh $UP_BIN/start_close_check.sh dfs start

#等待safemode结束 运行检查TODO
wait_for_safemode

sh $UP_BIN/hdfs_check.sh

echo "report check"
hdfs dfsadmin -report

stop-dfs.sh 
sh  $UP_BIN/start_close_check.sh dfs close

echo "如果你认为没问题就hdfs namenode  -finalize吧"
echo "ha 下不能哦"
