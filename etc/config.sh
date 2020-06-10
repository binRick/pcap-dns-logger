CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export PATH=$CUR_DIR/../bin:$PATH


VAR_LOG_PARSED_SYMLINK_DEST_PATH="/var/log/dns_logger.json"
INSTALL_PREFIX="/opt/dns_logger"
LOG_MAX_FILES_QTY="10"
LOG_FILE_MAX_BYTES="1048576"



LOCAL_DNS_SERVER_IP_ADDRESS="$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'| grep '^10\.'| head -n1)"
INTERFACE="$(ip r show|grep " src $LOCAL_DNS_SERVER_IP_ADDRESS" |cut -d " " -f 3,12)"
INTERFACE="eth0" #$(ip r show|grep " src $LOCAL_DNS_SERVER_IP_ADDRESS" |cut -d " " -f 3,12)"
DNSCAP_PCAP_FILTER="port 53"


cbordump=./cbordump
jq=./jq
dnscap=./dnscap
multilog=./multilog
reap=./reap
jo=./jo
logger=./logger.sh

BOR_TMP_SUBDIR=var/log/cbor
PARSED_LOG_SUBDIR=var/log/parsed

LOG_DIRECTORY="$CUR_DIR/../$PARSED_LOG_SUBDIR"
CBOR_FILE_HANDLER_SCRIPT="$CUR_DIR/../bin/cbor_file_handler.sh"
SYSTEMD_UNIT_SRC_FILE="$CUR_DIR/../etc/dns_logger.service"
SYSTEMD_TIMER_LOGS_UNIT_SRC_FILE="$CUR_DIR/../etc/dns_logger_normalize_log_files.service"
SYSTEMD_TIMER_LOGS_TIMER_SRC_FILE="$CUR_DIR/../etc/dns_logger_normalize_log_files.timer"
SYSTEMD_UNIT_DST_FILE="/usr/lib/systemd/system/dns_logger.service"
SYSTEMD_UNIT_DST_FILE_ETC="/etc/systemd/system/dns_logger.service"
SYSTEMD_TIMER_LOGS_UNIT_DST_FILE_ETC="/etc/systemd/system/dns_logger_normalize_log_files.service"
SYSTEMD_TIMER_LOGS_TIMER_DST_FILE_ETC="/etc/systemd/system/dns_logger_normalize_log_files.timer"
SYSTEMD_UNIT_DST_FILE_MODE=0600
SYSTEMD_UNIT_NAME=dns_logger
LOG_SYSTEMD_UNIT_NAME=dns_logger_normalize_log_files
CBOR_TMP_SUBDIR_PATH="$CUR_DIR/../$CBOR_TMP_SUBDIR"

VAR_LOG_PARSED_SYMLINK_SRC_PATH="$LOG_DIRECTORY/current"

PARSED_SYMLINK_CMD="([[ -e \"$VAR_LOG_PARSED_SYMLINK_SRC_PATH\" ]] && [[ ! -e \"$VAR_LOG_PARSED_SYMLINK_DEST_PATH\" ]] && command ln -s \"$VAR_LOG_PARSED_SYMLINK_SRC_PATH\" \"$VAR_LOG_PARSED_SYMLINK_DEST_PATH\")"
CP_SYSTEMD_UNIT_CMD="command cp -f \"$SYSTEMD_UNIT_SRC_FILE\" \"$SYSTEMD_UNIT_DST_FILE_ETC\"; command echo cp -f \"$SYSTEMD_UNIT_SRC_FILE\" \"$SYSTEMD_UNIT_DST_FILE\"; command chmod $SYSTEMD_UNIT_DST_FILE_MODE \"$SYSTEMD_UNIT_DST_FILE_ETC\"; command chown root:root \"$SYSTEMD_UNIT_DST_FILE_ETC\"; cp -f $SYSTEMD_TIMER_LOGS_UNIT_SRC_FILE $SYSTEMD_TIMER_LOGS_UNIT_DST_FILE_ETC ; cp -f $SYSTEMD_TIMER_LOGS_TIMER_SRC_FILE $SYSTEMD_TIMER_LOGS_TIMER_DST_FILE_ETC; command chown root:root $SYSTEMD_TIMER_LOGS_TIMER_DST_FILE_ETC $SYSTEMD_TIMER_LOGS_UNIT_DST_FILE_ETC; chmod $SYSTEMD_UNIT_DST_FILE_MODE $SYSTEMD_TIMER_LOGS_TIMER_DST_FILE_ETC $SYSTEMD_TIMER_LOGS_UNIT_DST_FILE_ETC; "
NORMALIZE_SYSTEMD_UNIT_CMD="command systemctl enable $SYSTEMD_UNIT_NAME; command systemctl is-enabled $SYSTEMD_UNIT_NAME && command systemctl restart $SYSTEMD_UNIT_NAME; sleep 5; systemctl status $SYSTEMD_UNIT_NAME; systemctl restart dns_logger_normalize_log_files.timer; systemctl enable dns_logger_normalize_log_files.timer; command systemctl disable $LOG_SYSTEMD_UNIT_NAME; command systemctl is-enabled $LOG_SYSTEMD_UNIT_NAME && command systemctl stop $LOG_SYSTEMD_UNIT_NAME; sleep 5; systemctl status $LOG_SYSTEMD_UNIT_NAME;"

