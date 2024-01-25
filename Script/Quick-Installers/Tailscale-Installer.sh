#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/tailscale_installer.log"

increment_log_file_name() {
  local log_file_base_name="tailscale_installer_run_"
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

dialog --title "Welcome" --msgbox "Welcome to the Tailscale VPN installer.\nPlease ensure you have your Tailscale authorization key ready." 10 50

# Use dialog for user input
authkey=$(dialog --stdout --inputbox "Enter your Tailscale authorization key:" 0 0)
use_exit_node_answer=$(dialog --stdout --yesno "Do you want to use an exit node?" 0 0)
additional_options=$(dialog --stdout --inputbox "Enter additional Tailscale options (leave blank for none):" 0 0)

# Install Tailscale
dialog --title "Installation" --infobox "Installing Tailscale..." 5 50
curl -fsSL https://tailscale.com/install.sh | sh

# Authenticate and connect to Tailscale
dialog --title "Authentication" --infobox "Authenticating and connecting to Tailscale with the provided authorization key..." 5 70
sudo tailscale up --authkey "$authkey"

# Check if the user wants to use an exit node
if [ "$use_exit_node_answer" == "0" ]; then
    exit_node_id=$(dialog --stdout --inputbox "Enter the Tailscale node ID for the exit node:" 0 0)
    sudo tailscale up --exit-node="$exit_node_id"
fi

# Apply additional options if provided
if [[ -n $additional_options ]]; then
    sudo tailscale up $additional_options
fi

dialog --title "Setup Complete" --msgbox "Tailscale VPN setup is complete." 5 70

