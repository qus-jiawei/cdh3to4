#!/usr/bin/env bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

start_zk(){
  sh $UP_BIN/start-zk.sh
  sh $UP_BIN/start_close_check.sh zk start
}

function formatZK(){
  expect -c ";
  spawn hdfs zkfc -formatZK;
  expect \"(Y or N)\";
  send \"Y\n\";
  exec sleep 1;
  send \"exit\n\";
  expect";
}

function initializeSharedEdits(){
  expect -c ";
  spawn hdfs namenode -initializeSharedEdits;
  expect \"(Y or N)\";
  send \"Y\n\";
  exec sleep 1;
  send \"exit\n\";
  expect";
}
function journlnode(){
    echo "init journalnode"
    start-journalnode.sh 
    echo "wait for journalnode start" 
    sh $UP_BIN/start_close_check.sh jn start
    initializeSharedEdits
    sleep 1
    echo "stop journalnode"
    stop-journalnode.sh
    sleep 1
    sh $UP_BIN/start_close_check.sh jn close
}

function rsync_namenode(){

    echo "copy file to HA namenode"

    NAME_PWD=`dirname $NAME_DIR`
    cd $NAME_PWD
    #tar -zcvf $UP_BACKUP/$UPGRADE_TAR name
    #ssh -p $SSH_PORT $STANDBY_NODE mkdir -p $NAME_PWD
    #scp -P $SSH_PORT $UP_BACKUP/$UPGRADE_TAR $STANDBY_NODE:$NAME_PWD
    #ssh -p $SSH_PORT $STANDBY_NODE tar -zxvf $NAME_PWD/$UPGRADE_TAR

    ssh -p $SSH_PORT $STANDBY_NODE mkdir -p $NAME_PWD
    scp -P $SSH_PORT -r $NAME_DIR $STANDBY_NODE:$NAME_PWD
}
echo "copying cdh4ha config back"
sh $UP_BIN/config_cdh4ha.sh


start_zk
echo "give you 10 second to check zookeeper"
sleep 5

journlnode

echo "give you 10 second to check journlnode"
sleep 10

rsync_namenode
echo "give you 10 second to check other node's name dir"
sleep 10



echo "format zk"
formatZK
sleep 5

echo "begin to start dfs"
start-dfs.sh
echo "wait for 20 and continue"
sleep 20
#TODO check
sh $UP_BIN/start_close_check.sh dfs start
wait_for_safemode
sh $UP_BIN/hdfs_check.sh
echo "begin to start yarn and historyserver"
start-yarn.sh
#sh $UP_BIN/start_close_check.sh yarn start
sh mr-jobhistory-daemon.sh start historyserver
echo "wait for 20 and continue"
sleep 20
#TODO check
sh $UP_BIN/mr_check.sh

