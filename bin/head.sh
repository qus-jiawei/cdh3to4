#!/bin/bash
#
#
#所有的运行脚本都存放在bin目录下，开头加入以下代码
#UP_BIN=$(cd $(dirname $0);pwd)
#. $UP_BIN/head.sh
#var_die $UP_ROOT
#运行脚本的初始化脚本

if [ "$HEAD_DEF" != "HEAD_DEF" ]; then
#***********************include once*************
echo "head def";
source ~/.bash_profile

if [ -z $UP_BIN ] ;then 
    echo "UP_BIN is null"
    exit;
fi;


UP_ROOT=$(dirname $UP_BIN);
UP_CONF=$UP_ROOT/conf
UP_CONF_BUILD=$UP_CONF/build
UP_CONF_TEMP=$UP_CONF/template
UP_CONF_PICK=$UP_CONF/pick
UP_DATA=$UP_ROOT/data
UP_LOG=$UP_ROOT/log
UP_BACKUP=$UP_ROOT/backup
########分发包的路径
CDH4_DIR="$UP_DATA/cdh4.2.1"
CDH4_CONF_DIR="$HOME/hadoop/etc/hadoop"
CDH4_HADOOP_JAR="hadoop-2.0.0-cdh4.2.1.tar.gz" 
CDH4_HBASE_JAR="hbase-0.94.2-cdh4.2.1.tar.gz"
CDH4_HIVE_JAR="hive-0.10.0-cdh4.2.1.tar.gz"
CDH4_ZK_JAR="zookeeper-3.4.5-cdh4.2.1.tar.gz"
JDK_1_7_TAR="jdk-7u21-linux-x64.gz"

#获取解压后的目录名，如果不一致可修改
CDH4_HADOOP_DIR=${CDH4_HADOOP_JAR%.tar.gz}
CDH4_HBASE_DIR=${CDH4_HBASE_JAR%.tar.gz}
CDH4_HIVE_DIR=${CDH4_HIVE_JAR%.tar.gz}
CDH4_ZK_DIR=${CDH4_ZK_JAR%.tar.gz}
JDK_1_7_DIR="jdk1.7.0_21"

##################
#CDH3回滚目录 仅测试环境有用
#CDH3_HADOOP_JAR目录需要用于upgrade的时候，复制旧版配置文件到新版的hadoop中
CDH3_DIR="$UP_DATA/cdh3"
CDH3_CONF_DIR="$HOME/hadoop/conf"
CDH3_HADOOP_JAR="hadoop-0.20.2-cdh3u4.tar.gz" 
CDH3_HBASE_JAR="hbase-0.90.6-cdh3u4.tar.gz"
CDH3_HIVE_JAR="hive-0.7.1-cdh3u4.tar.gz"
CDH3_ZK_JAR="zookeeper-3.3.5-cdh3u4.tar.gz"

CDH3_HADOOP_DIR=${CDH3_HADOOP_JAR%.tar.gz}
CDH3_HBASE_DIR=${CDH3_HBASE_JAR%.tar.gz}
CDH3_HIVE_DIR=${CDH3_HIVE_JAR%.tar.gz}
CDH3_ZK_DIR=${CDH3_ZK_JAR%.tar.gz}

TIME_VERSION=`date +%Y%m%d-%H-%M`


#以下是函数的预定义
die() { [ $# -gt 0 ] && echo "$@"; if [ "X$OLD_DIR" != "X" ]; then cd $OLD_DIR; fi; exit -1; }
var() { eval echo \$"$1"; }

var_die() { [ "`var $1`" == "" ] && die "var $1 is not definded" ||:; }
file_die() { if [ -e "$1" ]; then msg=${2:-"file $1 is already exists"}; die "$msg"; fi }
notfile_die() { if [ ! -e "$1" ]; then msg=${2:-"file $1 is not exists"}; die "$msg"; fi }
#等待safemode状态结束
wait_for_safemode(){

SAFEMODE="on"
while [ "$SAFEMODE" != "off" ];
do
    result=`hadoop dfsadmin -safemode get|grep OFF`
    if [ -z "$result" ];then 
        echo "safemode is on and sleep 1";
        sleep 1;
    else
        echo "safemode is off";
        SAFEMODE="off";
    fi;
done
}
#传送文件，并且校验
#$1 本地文件名 $2 目标机器 $3 目标文件名
scp_file_and_check(){
    i=0;
    echo "sending file to $2"
    while [ $i -le 2 ];
    do
        echo "checking md5..."
        check_result=`remote_file_check $1 $2 $3`
        if [ "$check_result" == "true" ];then
            echo "md5 match !!!! scp $1 to $2:$3 finish"
            break;
        else
            echo "md5 not match and send again"
            scp -P $SSH_PORT $1 $2:$3
        fi;
        i=`expr $i + 1`
    done
}
#远程文件校验
#$1 本地文件名 $2 目标机器 $3 目标文件名
#输出 true 或者 false
remote_file_check(){
    remotemd5=`ssh -p $SSH_PORT $2 "md5sum $3"`
    remote=${remotemd5:0:32}
    localmd5=`md5sum $1`
    local=${localmd5:0:32}
    if [ "$local" != "$remote" ];then
        echo "false";
    else
        echo "true";
    fi;
}

#myscp auto print params
myscp () { echo "send file from $1 to $2 ";scp -P ${SSH_PORT} $1 $2 >> /dev/null;}

#配置文件设置
xml_get() { a=`egrep -A 3 "<name>$2</name>" $1|egrep -o "<value>.*</value>"`;a="${a#<value>}";echo "${a%</value>}"; }
xml_set() { sed -r "/<name>$2<\/name>/{ n; s#<value>.*</value>#<value>$3</value>#; }" -i $1; }
#xml格式化，去掉空行和注释，方便配置项获取
xml_format() {
 sed  -i 's/<!--/\n<!--\n/' $1
 sed  -i 's/-->/\n-->\n/' $1
 sed  -i '/<!--/,/-->/ d' $1
 sed  -i '/-->/ d' $1
 sed  -i '/^\s*$/d' $1
}

#用户生成字符串序列数组，
#输入字符串模板和起始数字，结束数字，字符串模板中的#NUM#会被替换为数字
#$1 string template $2 begin $3 end
build_array(){
    string=$1
    begin=$2
    end=$3

    i=$begin
    while [ "$i" -le "$end" ];
    do
        temp=$string
        echo "${temp/\#NUM\#/$i}"
        i=`expr $i + 1`
    done
}
#函数的预定义结束
##################
mkdir -p $UP_LOG
mkdir -p $UP_BACKUP
mkdir -p $UP_CONF/pick
echo "UP_ROOT = $UP_ROOT"
cd $UP_ROOT

. $UP_CONF/config.sh

#***********************include once*************
HEAD_DEF="HEAD_DEF"
fi;
