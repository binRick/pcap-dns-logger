#!/bin/bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ../etc/config.sh

systemctl stop dns_logger; systemctl disable dns_logger; rm -rf /etc/systemd/system/dns_logger*; rm -rf /usr/lib/systemd/system/dns_logger*
