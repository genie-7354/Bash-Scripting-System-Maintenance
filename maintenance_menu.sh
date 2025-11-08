#!/usr/bin/env bash
set -euo pipefail
trap 'echo "⚠️ Error at line $LINENO"; read -rp "Press Enter..."' ERR

BASE="/opt/maintenance"
BACKUP="$BASE/backup.sh"
UPDATE="$BASE/update_clean.sh"
MONITOR="$BASE/log_monitor.sh"
LOGDIR="$BASE/logs"
MASTER_LOG="/var/log/maintenance_suite.log"

mkdir -p "$LOGDIR"
# ensure master log exists and is writable by root (we use sudo tee)
sudo touch "$MASTER_LOG" >/dev/null 2>&1 || true

timestamp() { date "+%Y-%m-%d %H:%M:%S"; }
log_to() { printf '[%s] %s\n' "$(timestamp)" "$*" | sudo tee -a "$MASTER_LOG" >/dev/null; }

pause() { read -rp "Press Enter to return to menu..."; }

while true; do
  clear
  echo "================================================"
  echo "  🧰  System Maintenance Suite - MENU"
  echo "================================================"
  echo "1) Run Backup Now"
  echo "2) Run Update & Cleanup"
  echo "3) Run Log Monitor"
  echo "4) Show Scripts Directory"
  echo "5) Run FULL Maintenance (with logging)"
  echo "6) Exit"
  echo "================================================"
  read -rp "Choose an option [1-6]: " choice

  case "$choice" in
    1)
      echo "→ Running backup..."
      log_to "Starting backup"
      sudo "$BACKUP" && log_to "Backup completed"
      pause
      ;;
    2)
      echo "→ Running update & cleanup..."
      log_to "Starting update & cleanup"
      sudo "$UPDATE" && log_to "Update & cleanup completed"
      pause
      ;;
    3)
      echo "→ Running log monitor..."
      log_to "Starting log monitor"
      sudo "$MONITOR" && log_to "Log monitor completed"
      echo "Monitor output (tail):"
      tail -n 20 "$LOGDIR"/log_monitor.log 2>/dev/null || true
      pause
      ;;
    4)
      echo "→ Listing $BASE"
      ls -l "$BASE"
      echo
      echo "Logs:"
      ls -l "$LOGDIR" 2>/dev/null || true
      echo
      echo "Master log: $MASTER_LOG"
      sudo tail -n 20 "$MASTER_LOG" 2>/dev/null || true
      pause
      ;;
    5)
      echo "→ Running FULL maintenance (1→2→3)…"
      log_to "===== FULL RUN started ====="
      echo "Step 1/3: Backup";           sudo "$BACKUP"   && log_to "Step 1 OK: Backup"
      echo "Step 2/3: Update/Cleanup";   sudo "$UPDATE"   && log_to "Step 2 OK: Update/Cleanup"
      echo "Step 3/3: Log Monitor";      sudo "$MONITOR"  && log_to "Step 3 OK: Log Monitor"
      log_to "===== FULL RUN finished ====="
      echo "Full run completed."
      pause
      ;;
    6)
      echo "Exiting. Bye! 👋"
      exit 0
      ;;
    *)
      echo "Invalid option. Try again."
      sleep 1
      ;;
  esac
done
