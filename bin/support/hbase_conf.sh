#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01


# 借用hadoop depolyer的配置脚本
# $1 FIX_HBASE_CONF

#配置文件
quorum=`echo $ZK_NODES|sed "s/ /,/g"`;
FIX_HBASE_CONF="$1"

HBASE="$FIX_HBASE_CONF/hbase-site.xml";
REGIONSERVERS="$FIX_HBASE_CONF/regionservers";
BACKUP_MASTERS="$FIX_HBASE_CONF/masters";

PP="${PORT_PREFIX}";
xml_set $HBASE hbase.tmp.dir $HOME/hbase_temp
xml_set $HBASE hbase.master.port ${PP}600
xml_set $HBASE hbase.master.info.port ${PP}610
xml_set $HBASE hbase.regionserver.port ${PP}620
xml_set $HBASE hbase.regionserver.info.port ${PP}630
xml_set $HBASE hbase.hregion.memstore.flush.size $((128*1024*1024)) 
xml_set $HBASE hbase.hregion.max.filesize $((512*1024*1024)) 
xml_set $HBASE hbase.hstore.blockingWaitTime 90000 
xml_set $HBASE zookeeper.znode.parent /hbase
xml_set $HBASE hbase.zookeeper.quorum "$quorum"
xml_set $HBASE hbase.zookeeper.peerport ${PP}288
xml_set $HBASE hbase.zookeeper.leaderport ${PP}388
xml_set $HBASE hbase.zookeeper.property.clientPort ${PP}181
xml_set $HBASE hbase.rest.port ${PP}880

echo "$RS_NODES" > $REGIONSERVERS;
echo ${BACKUP_HMASTERS} > $BACKUP_MASTERS;

