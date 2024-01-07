#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/tailscale_installer.log"  # Log file location

# Function to increment log file name
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

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

# RRHQD/Script/Quick-Installers/Tailscale-Installer.sh

# This script installs Tailscale VPN and allows users to start it with an authkey, exit node, and additional options

echo "Welcome to the Tailscale VPN installer."
echo "Please ensure you have your Tailscale authorization key ready."

# Prompt the user for the authorization key
read -p "Enter your Tailscale authorization key: " authkey

# Install Tailscale
echo "Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

# Authenticate and connect to Tailscale
echo "Authenticating and connecting to Tailscale with the provided authorization key..."
sudo tailscale up --authkey "$authkey"

# Check if the user wants to use an exit node
read -p "Do you want to use an exit node? (yes/no): " use_exit_node_answer
if [[ $use_exit_node_answer == "yes" ]]; then
    read -p "Enter the Tailscale node ID for the exit node: " exit_node_id
    sudo tailscale up --exit-node="$exit_node_id"
fi

# Refactored to allow setting various Tailscale options
echo "You can now set additional Tailscale options."
echo "Your input will be added after the Tailscale up command."
read -p "Enter additional Tailscale options (leave blank for none): " additional_options

# Apply additional options if provided
if [[ -n $additional_options ]]; then
    sudo tailscale up $additional_options
fi

echo "Tailscale VPN setup is complete."
