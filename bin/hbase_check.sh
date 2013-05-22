#!/bin/bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh

var_die UP_ROOT

echo '******************checking hbase*****************************'
echo '************************************************************'

t=`date +%Y%m%d-%H%M`

echo "
create 'hbase_check', 'cf' 
list 'hbase_check'
put 'hbase_check', 'row1', 'cf:a', 'value1'
put 'hbase_check', 'row2', 'cf:a', 'value2'
put 'hbase_check', 'row3', 'cf:a', 'value3'
scan 'hbase_check'
 get 'hbase_check', 'row1'
 disable 'hbase_check'
 drop 'hbase_check'

 create 'hbase_live', 'cf'
 put 'hbase_live', 'row${t}', 'cf:a', 'value1'
 put 'hbase_live', 'row${t}', 'cf:a', 'value2'
 scan 'hbase_live'
" | hbase shell

hadoop fs -ls /hbase
