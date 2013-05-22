#!/bin/bash
NODES="
platform30
platform31
platform32
platform33
platform34
"

$SSH_PORT=$SSH_PORT

for node in $NODES
do
echo $node
scp -P $SSH_PORT hadoop/* $node:~/${HADOOP_CONF_DIR}
#scp -P $SSH_PORT hive/* $node:~/hive-0.10.0-cdh4.2.1/conf
#scp -P $SSH_PORT zookeeper/* $node:~/zookeeper-3.4.5-cdh4.2.1/conf
done
