#!/bin/bash

# Configuration for logging
LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/reboot_sunday.log"  # Log file location for reboot script

# Function to increment log file name for reboot script
increment_log_file_name() {
  local log_file_base_name="reboot_sunday_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file for reboot script will be saved as $LOG_FILE"
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

source ~/RRHQD/Core/Core.sh

cronjob_entry="0 0 * * 0 root /sbin/reboot"

dialog --infobox "Adding reboot cron job for every Sunday..." 5 50

# Check if the reboot cron job already exists in /etc/crontab
if grep -qF -- "$cronjob_entry" /etc/crontab; then
    dialog --msgbox "Reboot cron job for every Sunday already exists in /etc/crontab. Aborting script." 6 50
    exit 1
else
    # Add the reboot cron job to /etc/crontab for every Sunday at 00:00
    echo "$cronjob_entry" >> /etc/crontab
    dialog --msgbox "Reboot cron job for every Sunday added to /etc/crontab successfully." 6 50
fi

