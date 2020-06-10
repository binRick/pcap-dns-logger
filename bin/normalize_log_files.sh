#!/bin/bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ../etc/config.sh

sleep 5
cmd="echo OK"
eval $cmd

exit 0
