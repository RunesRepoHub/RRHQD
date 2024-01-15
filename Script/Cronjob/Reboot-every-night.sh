#!/bin/bash

# Configuration for update script
LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/update.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="update_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file for update will be saved as $LOG_FILE"
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

source ~/RRHQD/Core/Core.sh

dialog --title "Check" --infobox "Checking for existing reboot cron job..." 5 70
sleep 2

# Function to check if a cron job exists in /etc/crontab
cron_job_exists() {
    local cron_entry="$1"
    
    # Use `grep` to check if the cron entry already exists in /etc/crontab
    grep -qF -- "$cron_entry" /etc/crontab
}

# Function to add a cron job to /etc/crontab
add_cron_job() {
    local cron_entry="$1"
    
    # Append the cron job to /etc/crontab
    echo "$cron_entry" | sudo tee -a /etc/crontab
    dialog --title "Cron Job Update" --msgbox "Reboot cron job added to /etc/crontab successfully." 10 50
}

# Get the current logged-in username
current_user="$(whoami)"
cronjob_entry="45 4 * * * $current_user /sbin/reboot"

# Add cron jobs if they do not exist in /etc/crontab
if cron_job_exists "$cronjob_entry"; then
    dialog --title "Cron Job Exists" --msgbox "Reboot cron job already exists in /etc/crontab. Aborting script." 10 50
    exit 1
else
    add_cron_job "$cronjob_entry"
fi


# Function to check if a cron job exists in the user's crontab
cron_job_exists_in_user() {
    local cronjob_entry="$1"
    
    # Use `grep` to check if the cron job already exists in the user's crontab
    crontab -l | grep -qF -- "$cronjob_entry"
}

# Function to add a cron job to the user's crontab
add_cron_job_to_user() {
    local cronjob_entry="$1"
    
    # Write out current crontab and add the new cron job
    (crontab -l; echo "$cronjob_entry") | crontab -
    dialog --title "Cron Job Update" --msgbox "Cron job added successfully." 10 50
}

# Check and add cron job to user's crontab if it does not exist
if ! cron_job_exists_in_user "$cronjob_entry"; then
    add_cron_job_to_user "$cronjob_entry"
fi
