#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/ansible_installer.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="ansible_installer_run_"
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

# Script to install and configure Ansible based on user inputs

echo "Ansible installation and configuration script."

# Prompt user for input with defaults
read -p "Enter the path for the Ansible inventory file (default: /etc/ansible/hosts): " INVENTORY_PATH
INVENTORY_PATH=${INVENTORY_PATH:-"/etc/ansible/hosts"}

# Check if the Ansible inventory file exists
if [ ! -f "$INVENTORY_PATH" ]; then
    echo "The Ansible inventory file does not exist. Creating it now..."
    mkdir -p "$(dirname "$INVENTORY_PATH")" && touch "$INVENTORY_PATH"
    echo "[all]" > "$INVENTORY_PATH"  # You may want to initialize it with a default group
fi

read -p "Enter the remote user for Ansible to use (default: ubuntu): " REMOTE_USER
REMOTE_USER=${REMOTE_USER:-"ubuntu"}

read -p "Enter the private key file path for SSH (default: ~/.ssh/id_rsa): " PRIVATE_KEY_PATH
PRIVATE_KEY_PATH=${PRIVATE_KEY_PATH:-"~/.ssh/id_rsa"}

# Install Ansible if not already installed
if ! command -v ansible >/dev/null 2>&1; then
    echo "Ansible is not installed. Installing now..."
    sudo apt-get update
    sudo apt-get install -y ansible
fi

# Create Ansible inventory file with user input
{
    echo "[defaults]"
    echo "inventory = $INVENTORY_PATH"
    echo "remote_user = $REMOTE_USER"
    echo "private_key_file = $PRIVATE_KEY_PATH"
} > /etc/ansible/ansible.cfg

# Inform the user that Ansible has been installed and configured
echo "Ansible has been installed and configured."

# Prompt user for various machine IPs
read -p "Enter Proxmox machine IPs separated by space: " -a PROXMOX_IPS
read -p "Enter Debian machine IPs separated by space: " -a DEBIAN_IPS
read -p "Enter Ubuntu machine IPs separated by space: " -a UBUNTU_IPS
read -p "Enter Testing machine IPs separated by space: " -a TESTING_IPS
read -p "Enter Customer machine IPs separated by space: " -a CUSTOMER_IPS
read -p "Enter Admin machine IPs separated by space: " -a ADMIN_IPS

# Write the IPs to the Ansible inventory file
{
    echo "[Proxmox]"
    for ip in "${PROXMOX_IPS[@]}"; do
        echo "$ip"
    done
    echo ""
    echo "[Debian]"
    for ip in "${DEBIAN_IPS[@]}"; do
        echo "$ip"
    done
    echo ""
    echo "[Ubuntu]"
    for ip in "${UBUNTU_IPS[@]}"; do
        echo "$ip"
    done
    echo ""
    echo "[Testing]"
    for ip in "${TESTING_IPS[@]}"; do
        echo "$ip"
    done
    echo ""
    echo "[Customer]"
    for ip in "${CUSTOMER_IPS[@]}"; do
        echo "$ip"
    done
    echo ""
    echo "[Admin]"
    for ip in "${ADMIN_IPS[@]}"; do
        echo "$ip"
    done
} >> "$INVENTORY_PATH"
