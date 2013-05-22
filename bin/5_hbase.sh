#!/usr/bin/env bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

start-hbase.sh
sh $UP_BIN/start_check.sh hbase
sh $UP_BIN/hbase_check.sh


