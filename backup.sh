#!/bin/bash
set -e
trap 'echo "Error occurred at line $LINENO"' ERR

# your backup commands...

BACKUP_DIR="/opt/maintenance/backups"
mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/backup-$(date +%F-%H-%M).tar.gz" /etc /home 2>/opt/maintenance/logs/backup.log
echo "Backup completed!"
