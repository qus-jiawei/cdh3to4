#!/bin/bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

echo "**********分发CDH3的包和配置文件*********"
echo "**********不修改软连接和环境配置文件*********"

file_die $CDH3_HADOOP_JAR
file_die $CDH3_HABASE_JAR
file_die $CDH3_HIVE_JAR
file_die $CDH3_ZK_JAR

echo $CDH3_DIR/$CDH3_HADOOP_JAR
echo $CDH3_HADOOP_DIR


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


#send_tar "$HADOOP_NODES" "$CDH3_DIR/$CDH3_HADOOP_JAR"  "~/$CDH3_HADOOP_JAR" "~/$CDH3_HADOOP_DIR"
#send_tar "$HBASE_NODES" "$CDH3_DIR/$CDH3_HBASE_JAR"  "~/$CDH3_HBASE_JAR" "~/$CDH3_HBASE_DIR"
#send_tar "$HIVE_NODES" "$CDH3_DIR/$CDH3_HIVE_JAR"  "~/$CDH3_HIVE_JAR" "~/$CDH3_HIVE_DIR"
#send_tar "$ZK_NODES" "$CDH3_DIR/$CDH3_ZK_JAR"  "~/$CDH3_ZK_JAR" "~/$CDH3_ZK_DIR"
for node in $NODES
do
#myscp "$UP_DATA/lzo/lib/hadoop-lzo-0.4.12.jar" "$node:~/$CDH3_HADOOP_DIR/lib"
#myscp "$UP_DATA/lzo/lib/native/Linux-amd64-64/*" "$node:~/$CDH3_HADOOP_DIR/lib/native/Linux-amd64-64"
myscp "$UP_DATA/mysql-connector-java-5.1.16-bin.jar" "$node:~/hive/lib/"
done


