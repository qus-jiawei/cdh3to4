#!/bin/bash

UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh

var_die UP_ROOT

echo "******************checking hdfs*****************************"
echo "************************************************************"

#hadoop fs -rmr /check

hadoop fs -mkdir /check/in
hadoop fs -mkdir /check/out
i=0
echo "copying file to hdfs"
while [ $i -le 5 ] 
do

echo -e "$i...\c"
hadoop fs -copyFromLocal $UP_DATA/hdfs_data /check/in/data_${TIME_VERSION}_${i}
hadoop fs -copyFromLocal $UP_DATA/hdfs_data.lzo /check/in/data_${TIME_VERSION}_${i}.lzo

i=`expr $i + 1`

done
echo "copying finish"

echo "try lsr"
hadoop fs -lsr /check
echo "try cat"
hadoop fs -cat /check/in/data_${TIME_VERSION}_1
hadoop fs -text /check/in/data_${TIME_VERSION}_1.lzo


touch $UP_LOG/hdfs_finish_`date +%Y%m%d-%H:%M:%S`
