#!/bin/bash

temp=`cat ${ZK_CONF_DIR}/zoo.cfg|grep -v '#'|grep clientPort`
port=${temp:11}

ZK_NODES=`cat ${ZK_CONF_DIR}/zoo.cfg|grep -v '#'|grep server|awk -F '=' '{split($2,a,":");print a[1];}'`

for node in $ZK_NODES
do

echo $node
echo "ls /
create /check_zk
get /check_zk
set /check_zk ${node}
quit"|sh ${ZK_BIN}/zkCli.sh -server ${node}:${port}
exit



done


