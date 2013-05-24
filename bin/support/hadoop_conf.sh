#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2012-09
# 借用hadoop depolyer的配置脚本
# $1 HADOOP_CONF_DIR

#ENVSH="$HADOOP_CONF_DIR/hadoop-env.sh"
FIX_CONF_DIR="$1"

CORE="$FIX_CONF_DIR/core-site.xml"
HDFS="$FIX_CONF_DIR/hdfs-site.xml"
PP=${PORT_PREFIX}

# core-site.xml
quorum=""
for s in $ZK_NODES; do
  if [ "$quorum" == "" ]; then
    quorum="$s:${PORT_PREFIX}181"
  else
    quorum="$quorum,$s:${PORT_PREFIX}181"
  fi
done
xml_set $CORE hadoop.tmp.dir "\${user.home}/hadoop_temp"
#quorum=`echo $ZK_NODES|sed "s/ /,/g"` #注意，前面的$ZK..变量不可以加引号"
xml_set $CORE ha.zookeeper.quorum $quorum

# hdfs-site.xml
i=1
for s in $NAME_NODES; do
  xml_set $HDFS dfs.namenode.rpc-address.mycluster.nn${i} "$s:${PP}900"
  xml_set $HDFS dfs.namenode.http-address.mycluster.nn${i} "$s:${PP}070"
  xml_set $HDFS dfs.namenode.https-address.mycluster.nn${i} "$s:${PP}470"
  let i++
done
xml_set $HDFS dfs.datanode.address "0.0.0.0:${PP}010" 
xml_set $HDFS dfs.datanode.ipc.address "0.0.0.0:${PP}020"
xml_set $HDFS dfs.datanode.http.address "0.0.0.0:${PP}075"
xml_set $HDFS dfs.namenode.secondary.http-address "0.0.0.0:${PP}090"

xml_set $HDFS dfs.ha.zkfc.port "${PP}819"

#xml_set $HDFS dfs.namenode.shared.edits.dir "file://$HOME/hadoop_ha_edit/nn_edit"
quorum=""
for s in $QJOURNAL_NODES; do
  if [ "$quorum" == "" ]; then
    quorum="$s:${PORT_PREFIX}485"
  else
    quorum="$quorum;$s:${PORT_PREFIX}485"
  fi
done
xml_set $HDFS dfs.ha.fencing.methods "sshfence($USER:$SSH_PORT)"
xml_set $HDFS dfs.ha.fencing.ssh.private-key-files $HOME/.ssh/id_rsa
#xml_set $HDFS dfs.namenode.name.dir file://$HOME/hadoop_name,file://$HOME/hadoop_nfs/name
#xml_set $HDFS dfs.namenode.name.dir file://$HOME/hadoop_name
xml_set $HDFS dfs.replication `[ ${#NN} -gt 9 ] && echo 3 || echo 2`
xml_set $HDFS dfs.cluster.administrators $USER
xml_set $HDFS dfs.permissions.superusergroup `groups`
xml_set $HDFS dfs.hosts $HADOOP_CONF_DIR/dfs.include
xml_set $HDFS dfs.hosts.exclude $HADOOP_CONF_DIR/dfs.exclude
xml_set $HDFS dfs.block.size $[128*1024*1024] 
xml_set $HDFS dfs.balance.bandwidthPerSec $[20*1024*1024]
xml_set $HDFS dfs.namenode.shared.edits.dir qjournal://$quorum/mycluster;
xml_set $HDFS dfs.journalnode.rpc-address 0.0.0.0:${PP}485
xml_set $HDFS dfs.journalnode.http-address  0.0.0.0:${PP}480
xml_set $HDFS dfs.hosts "${CDH4_CONF_DIR}/dfs.include"
xml_set $HDFS dfs.hosts.exclude "${CDH4_CONF_DIR}/dfs.exclude"


#这里不修改，上文已经修改
#xml_set $HDFS_P dfs.datanode.data.dir file://$HOME/hadoop_data/dfs/data

#yarn
YARN="$FIX_CONF_DIR/yarn-site.xml"
YARN_P="$FIX_CONF_DIR/yarn-site.private.xml"
MAPRED="$FIX_CONF_DIR/mapred-site.xml"

xml_set $YARN yarn.resourcemanager.address $RM:${PP}040
xml_set $YARN yarn.resourcemanager.scheduler.address $RM:${PP}030
xml_set $YARN yarn.resourcemanager.webapp.address $RM:${PP}088
xml_set $YARN yarn.resourcemanager.resource-tracker.address $RM:${PP}025
xml_set $YARN yarn.resourcemanager.admin.address $RM:${PP}141
xml_set $YARN yarn.nodemanager.localizer.address 0.0.0.0:${PP}840
xml_set $YARN yarn.nodemanager.address 0.0.0.0:${PP}841
xml_set $YARN yarn.nodemanager.webapp.address 0.0.0.0:${PP}842

MEM=`free -m|sed -n "2p"|sed -e "s/ \+/\t/g"|cut -f 2`
MB=$((MEM/2))
xml_set $YARN_P yarn.nodemanager.resource.memory-mb $MB

xml_set $MAPRED mapreduce.jobhistory.address $RM:${PP}120
xml_set $MAPRED mapreduce.jobhistory.webapp.address $RM:${PP}888
xml_set $MAPRED mapreduce.shuffle.port ${PP}880
xml_set $MAPRED mapreduce.client.submit.file.replication `[ ${#NN} -gt 9 ] && echo 6 || echo 2`

# masters & slaves
rm -rf $FIX_CONF_DIR/slaves
for dn in $DATA_NODES; do
  echo $dn >> $FIX_CONF_DIR/slaves;
done;

