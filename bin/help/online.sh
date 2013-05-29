#!/bin/bash

UP_BIN=$(cd $(dirname $0);pwd)
UP_BIN=$(dirname "$UP_BIN")
UP_CONF=$UP_BIN/../conf

echo "online"
rm $UP_CONF/config.sh -rf
ln -s $UP_CONF/config.sh_online $UP_CONF/config.sh
rm $UP_CONF/private_config.sh -rf
ln -s $UP_CONF/private_config.sh_online $UP_CONF/private_config.sh

