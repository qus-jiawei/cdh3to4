#!/usr/bin/env bash
# coding=utf-8
# Author: zhaigy@ucweb.com
# Data:   2013-01


# 借用hadoop depolyer的配置脚本
# $1 FIX_HIVE_CONF  

#配置文件

#zookeeper 配置有bug 只能配置一个
for node in $ZK_NODES
do
    quorum=$node;
    break;
done
#quorum=`echo $ZK_NODES|sed "s/ /,/g"`;

FIX_HIVE_CONF="$1"

HIVE="$FIX_HIVE_CONF/hive-site.xml";
xml_format $HIVE

PP="${PORT_PREFIX}";

#####有sed重复替换的bug
temp="jdbc:mysql://$HIVE_MYSQL_HOST:$HIVE_MYSQL_PORT/$HIVE_MYSQL_DATABASE?createDatabaseIfNotExist=true&amp;useUnicode=true&amp;characterEncoding=utf8"
#xml_set $HIVE "javax.jdo.option.ConnectionURL" $temp
sed 's/HIVE_JDBC_MYSQL/$temp/' -i $HIVE
################

xml_set $HIVE "javax.jdo.option.ConnectionUserName" "$HIVE_MYSQL_USER"
xml_set $HIVE "javax.jdo.option.ConnectionPassword" "$HIVE_MYSQL_PASSWD"
xml_set $HIVE "javax.jdo.option.ConnectionDriverName" "com.mysql.jdbc.Driver"

#TODO 可能对mysql初始化校验有效
#xml_set $HIVE "datanucleus.validateTables"
#xml_set $HIVE "datanucleus.validateColumns"
#xml_set $HIVE "datanucleus.validateConstraints"


#直接设置为PP181
#clienPort=` grep port $build_zk_file |awk -F '=' '{print $2}'`
xml_set $HIVE "hive.zookeeper.quorum" "$quorum"
xml_set $HIVE "hive.zookeeper.client.port" "${PP}181"

xml_set $HIVE "hbase.zookeeper.quorum" "$quorum"
xml_set $HIVE "hbase.zookeeper.property.clientPort" "${PP}181"

#todo
#xml_set $HIVE "hive.aux.jars.path" ""
#xml_set $HIVE "hive.exec.scratchdir" "$HOME/hive_temp/"
#xml_set $HIVE "hive.querylog.location" "$HOME/hive_temp/"













