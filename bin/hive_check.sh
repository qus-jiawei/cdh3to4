#!/bin/bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh

var_die UP_ROOT

echo "******************checking hive*****************************"
echo "************************************************************"

hive shell -f $UP_DATA/'hive.sql';

