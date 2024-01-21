#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/fail2ban_installer.log"  # Log file location

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

mkdir -p "$LOG_DIR"
increment_log_file_name
exec > >(tee -a "$LOG_FILE") 2>&1

# Check for dialog command
if ! command -v dialog >/dev/null 2>&1; then
    echo "This script requires 'dialog'. Install it with 'sudo apt-get install dialog'"
    exit 1
fi

echo "Fail2ban setup and configuration script."

# Use dialog for user input
EMAIL=$(dialog --stdout --inputbox "Enter the email address for fail2ban notifications:" 0 0 "admin@example.com")
BANTIME=$(dialog --stdout --inputbox "Enter the ban time in seconds (e.g., 3600):" 0 0 "3600")
FINDTIME=$(dialog --stdout --inputbox "Enter the find time in seconds (e.g., 600):" 0 0 "600")
MAXRETRY=$(dialog --stdout --inputbox "Enter the max retry attempts:" 0 0 "5")

# Check for empty input and set default variables if necessary
EMAIL=${EMAIL:-"admin@example.com"}
BANTIME=${BANTIME:-3600}
FINDTIME=${FINDTIME:-600}
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

