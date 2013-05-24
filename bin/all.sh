#!/bin/bash

UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh

var_die UP_ROOT

i=0
for node in $NODES
do
echo $node
ssh -p $SSH_PORT $node "$1"
i=`expr $i + 1`

done
