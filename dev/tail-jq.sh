#!/bin/bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ../etc/config.sh


cmd="command tail -q -n0 -f $VAR_LOG_PARSED_SYMLINK_SRC_PATH| $jq"
eval $cmd
