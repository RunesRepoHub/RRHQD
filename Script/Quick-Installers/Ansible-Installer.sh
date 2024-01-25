#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/ansible_installer.log"

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

mkdir -p "$LOG_DIR"
increment_log_file_name
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Ansible installation and configuration script."

# Check for dialog command
if ! command -v dialog >/dev/null 2>&1; then
    echo "This script requires 'dialog'. Install it with 'sudo apt-get install dialog'"
    exit 1
fi

# Use dialog for user input
INVENTORY_PATH=$(dialog --stdout --inputbox "Enter the path for the Ansible inventory file:" 0 0 "/etc/ansible/hosts")
REMOTE_USER=$(dialog --stdout --inputbox "Enter the remote user for Ansible to use:" 0 0 "ubuntu")
PRIVATE_KEY_PATH=$(dialog --stdout --inputbox "Enter the private key file path for SSH:" 0 0 "~/.ssh/id_rsa")

# Check for empty input and set default variables if necessary
INVENTORY_PATH=${INVENTORY_PATH:-"/etc/ansible/hosts"}
REMOTE_USER=${REMOTE_USER:-"ubuntu"}
PRIVATE_KEY_PATH=${PRIVATE_KEY_PATH:-"$HOME/.ssh/id_rsa"}


# Handle cancellation of dialog
if [ "$?" -ne 0 ]; then
    echo "Script cancelled by user."
    exit 1
fi

if [ ! -f "$INVENTORY_PATH" ]; then
    echo "The Ansible inventory file does not exist. Creating it now..."
    mkdir -p "$(dirname "$INVENTORY_PATH")" && touch "$INVENTORY_PATH"
    echo "[all]" > "$INVENTORY_PATH"
fi

if ! command -v ansible >/dev/null 2>&1; then
    echo "Ansible is not installed. Installing now..."
    sudo apt-get update
    sudo apt-get install -y ansible
fi

{
    echo "[defaults]"
    echo "inventory = $INVENTORY_PATH"
    echo "remote_user = $REMOTE_USER"
    echo "private_key_file = $PRIVATE_KEY_PATH"
} > /etc/ansible/ansible.cfg

# Use dialog to get machine IPs
PROXMOX_IPS=$(dialog --stdout --inputbox "Enter Proxmox machine IPs separated by space:" 0 0)
DEBIAN_IPS=$(dialog --stdout --inputbox "Enter Debian machine IPs separated by space:" 0 0)
UBUNTU_IPS=$(dialog --stdout --inputbox "Enter Ubuntu machine IPs separated by space:" 0 0)
TESTING_IPS=$(dialog --stdout --inputbox "Enter Testing machine IPs separated by space:" 0 0)
CUSTOMER_IPS=$(dialog --stdout --inputbox "Enter Customer machine IPs separated by space:" 0 0)
ADMIN_IPS=$(dialog --stdout --inputbox "Enter Admin machine IPs separated by space:" 0 0)

# Handle cancellation of dialog
if [ "$?" -ne 0 ]; then
    echo "Machine IPs input cancelled by user."
    exit 1
fi

# Write the IPs to the Ansible inventory file
{
    echo "[Proxmox]"
    for ip in $PROXMOX_IPS; do
        echo "$ip"
    done
    echo ""
    echo "[Debian]"
    for ip in $DEBIAN_IPS; do
        echo "$ip"
    done
    echo ""
    echo "[Ubuntu]"
    for ip in $UBUNTU_IPS; do
        echo "$ip"
    done
    echo ""
    echo "[Testing]"
    for ip in $TESTING_IPS; do
        echo "$ip"
    done
    echo ""
    echo "[Customer]"
    for ip in $CUSTOMER_IPS; do
        echo "$ip"
    done
    echo ""
    echo "[Admin]"
    for ip in $ADMIN_IPS; do
        echo "$ip"
    done
} >> "$INVENTORY_PATH"

echo "Ansible has been installed and configured."

