#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/filezilla_installer.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="filezilla_installer_run_"
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

# RRHQD/Script/Quick-Installers/Filezilla-Installer.sh

source ~/RRHQD/Core/Core.sh

echo -e "${Green}Starting Filezilla installation on Debian machine...${NC}"

# Update package list
sudo apt update

# Install Filezilla
sudo apt install -y filezilla

echo -e "${Green}Filezilla installation is complete.${NC}"
