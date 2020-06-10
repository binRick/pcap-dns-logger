#!/bin/bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ../etc/config.sh
CBOR_FILE="$1"
[[ ! -d "$CBOR_TMP_SUBDIR_PATH" ]] && mkdir -p "$CBOR_TMP_SUBDIR_PATH"
[[ ! -d "$LOG_DIRECTORY" ]] && mkdir -p "$LOG_DIRECTORY"

#(set +e; [[ ! -h "$VAR_LOG_PARSED_SYMLINK_DEST_PATH" ]] || [[ -a "$VAR_LOG_PARSED_SYMLINK_DEST_PATH" ]] && unlink "$VAR_LOG_PARSED_SYMLINK_DEST_PATH")
#(set +e; [[ ! -h "$VAR_LOG_PARSED_SYMLINK_DEST_PATH" ]] || eval $PARSED_SYMLINK_CMD)

if [[ "$_REAP_EXEC" != "1" ]]; then
    cmd="_REAP_EXEC=1 exec $reap -x ./$(basename ${BASH_SOURCE[0]}) $@"
    eval $cmd
fi

cmd="$dnscap -i $INTERFACE -N -w $CBOR_TMP_SUBDIR_PATH -F cbor -k \"$CBOR_FILE_HANDLER_SCRIPT\" -u 53 -U '$DNSCAP_PCAP_FILTER' -s r -d"
eval $cmd
