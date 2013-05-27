

#特殊配置替换
#需要替换的配置均使用井号包括
        DFS_DATA_DIR=`xml_get ${UP_CONF_PICK}/hadoop/$node/hdfs-site.xml "dfs.data.dir"`
        echo "$node 's DSF_DATA_DIR is ${DFS_DATA_DIR}"
        xml_set ${UP_CONF_BUILD}/cdh4ha/hadoop/$node/hdfs-site.private.xml "dfs.data.dir" $DFS_DATA_DIR
        
        DFS_NAME_DIR=`xml_get ${UP_CONF_PICK}/hadoop/$node/hdfs-site.xml "dfs.name.dir"`
        echo "$node 's DFS_NAME_DIR is ${DFS_NAME_DIR}"
        xml_set ${UP_CONF_BUILD}/cdh4ha/hadoop/$node/hdfs-site.xml "dfs.name.dir" $DFS_NAME_DIR
        xml_set ${UP_CONF_BUILD}/cdh4ha/hadoop/$node/hdfs-site.xml "dfs.namenode.name.dir" $DFS_NAME_DIR
 
