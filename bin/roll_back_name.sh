#!/usr/bin/env bash
UP_BIN=$(cd $(dirname $0);pwd)
. $UP_BIN/head.sh
var_die UP_ROOT

echo "roll back name dir from $UP_BACKUP/$BACKUP_TAR"
cd `dirname $NAME_DIR`
rm  $NAME_DIR/name -rf
tar -zxvf $UP_BACKUP/$BACKUP_TAR name
