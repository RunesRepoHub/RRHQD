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

echo -e "${Green}Checking for existing reboot cron job...${NC}"

cronjob_entry="45 4 * * * root /sbin/reboot"

# Check if the reboot cron job already exists in /etc/crontab
if grep -qF -- "$cronjob_entry" /etc/crontab; then
    echo -e "${Red}Reboot cron job already exists in /etc/crontab. Aborting script.${NC}"
    exit 1
else
    # Add the reboot cron job to /etc/crontab
    echo "$cronjob_entry" >> /etc/crontab
    echo -e "${Green}Reboot cron job added to /etc/crontab successfully.${NC}"
fi


# Define a non-root user variable
# Get the current logged-in user
NON_ROOT_USER=$(whoami)

# Function to run commands as non-root user
run_as_non_root_user() {
  sudo -u $NON_ROOT_USER "$@"
}

# Add the reboot cron job to the user's crontab instead of /etc/crontab
cronjob_entry="45 4 * * * /sbin/reboot"

# Check if the reboot cron job already exists in the user's crontab
if sudo -u $NON_ROOT_USER crontab -l | grep -qF -- "$cronjob_entry"; then
    echo -e "${Red}Reboot cron job already exists for user $NON_ROOT_USER. Aborting script.${NC}"
    exit 1
else
    # Add the reboot cron job to the user's crontab
    (sudo -u $NON_ROOT_USER crontab -l; echo "$cronjob_entry") | sudo -u $NON_ROOT_USER crontab -
    echo -e "${Green}Reboot cron job added for user $NON_ROOT_USER successfully.${NC}"
fi
