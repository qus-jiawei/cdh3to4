#!/bin/bash

#被bin/support/private_conf.sh调用,bin/support/private_conf.sh中提供一些帮助函数
#按照格式 filename#hostname#配置项key#配置项value 方式输出，以#划分
#一个配置一行
#可以使用helper function
#build_conf
#遍历host数组和目录数组输出可操作的private修改格式队列
#$1 hosts  $2 conf name  $3 dirs $4 file name
#build_array
#用户生成字符串序列数组，
#输入字符串模板和起始数字，结束数字，字符串模板中的#NUM#会被替换为数字
#$1 string template $2 begin $3 end
################################################################################

hosts=`build_array platform#NUM# 31 34`
dirs=`build_array /home#NUM#/hadoop_data 9 10`
build_conf "$hosts" "dfs.data.dir" "$dirs" "hdfs-site.private.xml"

dirs=`build_array /home#NUM#/yarn_nm/local-dir 9 10`
build_conf "$hosts" "yarn.nodemanager.local-dirs" "$dirs" "yarn-site.private.xml"

dirs=`build_array /home#NUM#/yarn_nm/log-dir 9 10`
build_conf "$hosts" "yarn.nodemanager.log-dirs" "$dirs" "yarn-site.private.xml"

dirs=`build_array /home#NUM#/yarn_nm/log-dir 9 10`
build_conf "$hosts" "mapreduce.cluster.local.dir" "$dirs" "mapred-site.private.xml"

