#!/bin/bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die $UP_ROOT


echo "******************checking mr*******************************"
echo "************************************************************"
echo "remove output"
hadoop fs -rmr /check/out
echo "run easy mr"
hadoop jar $UP_DATA/hadoop-example.jar wordcount /check/in /check/out
echo "try output"
hadoop fs -lsr /check/out
hadoop fs -cat /check/out/part-r-00000

touch $UP_LOG/mr_finish_`date +%Y%m%d-%H:%M:%S`
