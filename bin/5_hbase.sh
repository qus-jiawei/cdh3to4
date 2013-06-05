#!/usr/bin/env bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

ssh -p ${SSH_PORT} $START_HMASTER ". ~/.bash_profile;. $HBASE_BIN/start-hbase.sh;"
sh $UP_BIN/start_close_check.sh hbase start
echo "wait for 30s hbase to init "
sleep 30
sh $UP_BIN/hbase_check.sh


