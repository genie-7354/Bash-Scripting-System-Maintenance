#!/bin/bash
set -e
trap 'echo "Error occurred at line $LINENO"' ERR

# rest of your log monitoring code...
LOGFILE="/var/log/syslog"
OUTPUT="/opt/maintenance/logs/log_monitor.log"

grep -i "error" $LOGFILE >> $OUTPUT

echo "Log monitoring completed!"
