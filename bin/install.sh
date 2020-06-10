#!/bin/bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ../etc/config.sh

eval $CP_SYSTEMD_UNIT_CMD
eval $NORMALIZE_SYSTEMD_UNIT_CMD
