#!/bin/bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

echo "**********分发CDH4的包和配置文件*********"
echo "**********不修改软连接和环境配置文件*********"

file_die $CDH4_HADOOP_JAR
file_die $CDH4_HABASE_JAR
file_die $CDH4_HIVE_JAR
file_die $CDH4_ZK_JAR

echo $CDH4_DIR/$CDH4_HADOOP_JAR
echo $CDH4_HADOOP_DIR


#传送，分发，删除，解压
# $1 机器群 $2 要分发的JAR包 $3 目标JAR包 $4 要删除的路径
send_tar(){
    for node in $1
    do
        scp_file_and_check $2 $node $3
        if [ "$FORCE_UNTAR" == "true" ];then
            ssh -p $SSH_PORT $node "
            rm -rf $4;
            echo 'remove $4 and untar $3';
            tar -zxf $3
            "
        else
            ssh -p $SSH_PORT $node "
                if [ -d $4 ];then 
                    echo 'dir find and skip untar ...';
                else
                    tar -zxf $3
                    echo 'untar finish ... ';
                fi;
                "
        fi;
    done
}


send_tar "$NODES" "$CDH4_DIR/$CDH4_HADOOP_JAR"  "~/$CDH4_HADOOP_JAR" "~/$CDH4_HADOOP_DIR"
send_tar "$NODES" "$CDH4_DIR/$CDH4_HBASE_JAR"  "~/$CDH4_HBASE_JAR" "~/$CDH4_HBASE_DIR"
send_tar "$HIVE_NODES" "$CDH4_DIR/$CDH4_HIVE_JAR"  "~/$CDH4_HIVE_JAR" "~/$CDH4_HIVE_DIR"
send_tar "$ZK_NODES" "$CDH4_DIR/$CDH4_ZK_JAR"  "~/$CDH4_ZK_JAR" "~/$CDH4_ZK_DIR"

#发送SBIN 脚本
for node in $NODES
do
echo "send $node hadoop sbin  file ... to ~/$CDH4_HADOOP_DIR/sbin"
scp -P $SSH_PORT  $UP_CONF/cdh4_sbin/hadoop_sbin/* $node:~/$CDH4_HADOOP_DIR/sbin >> /dev/null
done


for node in $HIVE_NODES
do
echo "send $node hive config  file ... to ~/$CDH4_HIVE_DIR/bin"
scp -P $SSH_PORT  $UP_CONF/cdh4_sbin/hive_sbin/* $node:~/$CDH4_HIVE_DIR/bin  >>/dev/null
done


for node in $ZK_NODES
do
echo "send $node zoo file ... to ~/$CDH4_ZK_DIR/bin"
scp -P $SSH_PORT  $UP_CONF/cdh4_sbin/zk_sbin/* $node:~/$CDH4_ZK_DIR/bin >>/dev/null
done

#发送lzo包
for node in $NODES
do
myscp "$UP_DATA/lzo/lib/hadoop-lzo-0.4.12.jar" "$node:~/$CDH4_HADOOP_DIR/share/hadoop/common/lib"
myscp "$UP_DATA/lzo/lib/native/Linux-amd64-64/*" "$node:~/$CDH4_HADOOP_DIR/lib/native/"

done

#发送mysql包
for node in $HIVE_NODES
do
myscp "$UP_DATA/mysql-connector-java-5.1.16-bin.jar" "$node:~/$CDH4_HIVE_DIR/lib/"
done
