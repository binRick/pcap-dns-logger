#!/bin/bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cmd="command nodemon -w . -e sh,py,yaml,json -x ./start.sh $@"
eval $cmd
