#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
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

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Installing dialog package for better user interface..."
    sudo apt-get update && sudo apt-get install dialog -y
fi

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

source ~/RRHQD/Core/Core.sh

# Use dialog to confirm installation
if dialog --title "Filezilla Installation" --yesno "Do you want to install Filezilla on this Debian machine?" 7 60; then
    echo -e "${Green}Starting Filezilla installation on Debian machine...${NC}"
    
    # Update package list
    sudo apt update
    
    # Install Filezilla
    sudo apt install -y filezilla
    
    echo -e "${Green}Filezilla installation is complete.${NC}"
    dialog --title "Installation Complete" --msgbox "Filezilla installation is complete." 5 50
else
    echo "Filezilla installation cancelled."
    dialog --title "Installation Cancelled" --msgbox "Filezilla installation was cancelled." 5 50
fi

