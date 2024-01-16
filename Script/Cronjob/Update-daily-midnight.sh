#!/bin/bash

# Configuration for logging
LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/update_daily_midnight.log"  # Log file location for update script

# Function to increment log file name for update script
increment_log_file_name() {
  local log_file_base_name="update_daily_midnight_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file for update script will be saved as $LOG_FILE"
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

source ~/RRHQD/Core/Core.sh

add_update_cronjob() {
    local update_command="apt-get update && apt-get upgrade -y"
    local cronjob_entry="0 0 * * * root $update_command"

    # Check if the update cron job already exists in /etc/crontab
    if grep -qF -- "$update_command" /etc/crontab; then
        dialog --msgbox "Update cron job already exists in /etc/crontab. No changes made." 6 50
    else
        # Add the update cron job to /etc/crontab
        if echo "$cronjob_entry" >> /etc/crontab; then
            dialog --msgbox "Update cron job added to /etc/crontab successfully." 6 50
        else
            dialog --msgbox "Failed to add update cron job to /etc/crontab." 6 50
            return 1
        fi
    fi
}

# Call the function to add the cron job
add_update_cronjob

