#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/fail2ban_installer.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="fail2ban_installer_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file will be saved as $LOG_FILE"
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

# RRHQD/Script/Quick-Installers/Fail2ban-Installer.sh
# Script to setup and configure Fail2ban with user input

echo "Fail2ban setup and configuration script."

# Prompt user for input with defaults
read -p "Enter the email address for fail2ban notifications: " EMAIL
EMAIL=${EMAIL:-"admin@example.com"}

read -p "Enter the ban time in seconds (e.g., 3600): " BANTIME
BANTIME=${BANTIME:-3600}

read -p "Enter the find time in seconds (e.g., 600): " FINDTIME
FINDTIME=${FINDTIME:-600}

read -p "Enter the max retry attempts: " MAXRETRY
MAXRETRY=${MAXRETRY:-5}

# Install Fail2ban if not already installed
if ! command -v fail2ban-server >/dev/null 2>&1; then
    echo "Fail2ban is not installed. Installing now..."
    sudo apt-get update
    sudo apt-get install -y fail2ban
fi

# Configure Fail2ban with the user input
{
    echo "[DEFAULT]"
    echo "destemail = $EMAIL"
    echo "banTime = $BANTIME"
    echo "findtime = $FINDTIME"
    echo "maxretry = $MAXRETRY"
} > /etc/fail2ban/jail.local

# Restart Fail2ban to apply the new configuration
sudo systemctl restart fail2ban

# Inform the user that Fail2ban has been configured
echo "Fail2ban has been configured and restarted with the new settings."
