#!/bin/bash

# Script to scan all drives for failures, bad sectors, and S.M.A.R.T status
# Outputs the information in dialog boxes for easy overview

# Function to check and display drive health
check_drive_health() {
  local drive=$1
  local temp_file=$(mktemp /tmp/drive_health.XXXXXX)
  
  {
    echo "Checking drive $drive for failures and bad sectors..."
    sudo smartctl -H -l error $drive
    echo "Checking S.M.A.R.T status..."
    sudo smartctl -A $drive
  } | tee "$temp_file"

  dialog --title "Drive Health Information for $drive" --textbox "$temp_file" 0 0
  rm -f "$temp_file"
}

# Check if smartmontools is installed, if not install it
if ! command -v smartctl &> /dev/null; then
  dialog --title "Smartmontools Installation" --infobox "Installing smartmontools, which is required for S.M.A.R.T checks..." 5 70
  sudo apt-get update && sudo apt-get install smartmontools -y
fi

# Detect all connected drives
drives=$(lsblk -nd --output NAME)
drive_array=()
for drive in $drives; do
  drive_array+=("$drive" "$drive")
done

# Use dialog to select a drive to check
drive_choice=$(dialog --title "Select Drive" --menu "Choose a drive to check:" 15 40 4 "${drive_array[@]}" 3>&1 1>&2 2>&3)
clear

# Run health check on the selected drive if not empty
if [ -n "$drive_choice" ]; then
  check_drive_health "/dev/$drive_choice"
else
  dialog --title "No Drive Selected" --msgbox "No drive was selected. Exiting." 5 50
fi

# Final message
dialog --title "Scan Complete" --msgbox "Drive scan complete. Please close this window." 6 50

