#!/bin/bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ../etc/config.sh
CBOR_FILE="$1"

cmd="$cbordump -j $CBOR_FILE   | $jq '.[]' -Mrc | $logger"

set +e
eval $cmd

[[ -f "$CBOR_FILE" ]] && command unlink "$CBOR_FILE"
