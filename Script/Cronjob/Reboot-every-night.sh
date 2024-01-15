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



# Ensure the script is being run as root
if [[ $EUID -ne 0 ]]; then
    echo -e "${Red}This script must be run as root. Aborting.${NC}"
    exit 1
fi

# Define the cronjob entry to reboot the system
cronjob_reboot_entry="0 2 * * * root /sbin/reboot"

# Function to add a cronjob for rebooting Ubuntu
add_reboot_cronjob() {
    echo -e "${Green}Attempting to add reboot cron job...${NC}"

    # Check if reboot cron job already exists
    if ! grep -qF -- "$cronjob_reboot_entry" /etc/crontab; then
        # Add the reboot cron job to /etc/crontab
        echo "$cronjob_reboot_entry" >> /etc/crontab
        echo -e "${Green}Reboot cron job added to /etc/crontab successfully.${NC}"
    else
        echo -e "${Yellow}Reboot cron job already exists. No changes made.${NC}"
    fi
}

# Call the function to add the reboot cron job
add_reboot_cronjob

# Display a message indicating the cron job was added
echo -e "${Green}Cron job added successfully.${NC}"