#!/bin/bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh

var_die UP_ROOT

echo "${ZK_CONF_DIR}"

CONF=${UP_CONF_BUILD}/cdh4

for node in $NODES
do
myscp "$CONF/hadoop/$node/*" "$node:${CDH4_CONF_DIR}"                                       
done

