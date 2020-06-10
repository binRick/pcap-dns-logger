#!/bin/bash
set -e
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ../etc/config.sh

set +e

systemctl is-enabled dns_logger.service
systemctl status dns_logger.service

systemctl is-enabled dns_logger_normalize_log_files.service
systemctl status dns_logger_normalize_log_files.service

systemctl list-timers

ls -al /opt/dns_logger/var/log/cbor
ls -al /opt/dns_logger/var/log/parsed
ls -al /var/log/dns*
