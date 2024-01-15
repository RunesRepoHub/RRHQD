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

# Determine the current user for the cron job
current_user=$(whoami)

# Set the cron job entry for reboot
cronjob_entry="45 4 * * * $current_user /sbin/reboot"

# Function to add cron job entry
add_cron_job() {
    # Check the OS and adjust the crontab file path accordingly
    local crontab_file="/etc/crontab"
    if [[ -f "/etc/os-release" ]]; then
        . /etc/os-release
        case $ID in
            debian|ubuntu|kali|linuxmint|zorin)
                crontab_file="/etc/crontab"
                ;;
            *)
                echo -e "${Red}Unsupported OS: $ID. Aborting script.${NC}"
                exit 1
                ;;
        esac
    else
        echo -e "${Red}Cannot determine OS. Aborting script.${NC}"
        exit 1
    fi

    # Check if the reboot cron job already exists in the crontab file
    if grep -qF -- "$cronjob_entry" "$crontab_file"; then
        echo -e "${Red}Reboot cron job already exists in $crontab_file. Aborting script.${NC}"
        exit 1
    else
        # Add the reboot cron job to the crontab file
        echo "$cronjob_entry" >> "$crontab_file"
        echo -e "${Green}Reboot cron job added to $crontab_file successfully.${NC}"
    fi
}

# Call the function to add the cron job
add_cron_job

