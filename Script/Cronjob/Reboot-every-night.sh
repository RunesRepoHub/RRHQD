#!/bin/bash

# Configuration for logging
LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/reboot_every_night.log"  # Log file location for reboot script

# Function to increment log file name for reboot script
increment_log_file_name() {
  local log_file_base_name="reboot_every_night_run_"
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

cron_job_exists() {
    local cron_command="$1"
    grep -qF "$cron_command" /etc/crontab
}

add_cron_job() {
    local cron_command="$1"
    echo "$cron_command" | sudo tee -a /etc/crontab >/dev/null
    echo "Cron job added: $cron_command"
}

reboot_job="45 4 * * * root /sbin/reboot"

if cron_job_exists "$reboot_job"; then
    dialog --msgbox "Reboot cron job already exists in /etc/crontab. Aborting script." 6 50
    exit 1
else
    add_cron_job "$reboot_job"
    dialog --msgbox "Reboot cron job added to /etc/crontab successfully." 6 50
    exit 0
fi

