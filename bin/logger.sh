#!/bin/bash
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ../etc/config.sh
[[ ! -d "$LOG_DIRECTORY" ]] && mkdir -p "$LOG_DIRECTORY"
exec $multilog s$LOG_FILE_MAX_BYTES n$LOG_MAX_FILES_QTY "$LOG_DIRECTORY"
