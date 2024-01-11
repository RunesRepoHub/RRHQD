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
  echo "Installing smartmontools, which is required for S.M.A.R.T checks..."
  sudo apt-get update && sudo apt-get install smartmontools -y
fi

# Detect all connected drives
drives=$(lsblk -nd --output NAME)

# Loop through each connected drive and check its health
for drive in $drives; do
  check_drive_health "/dev/$drive"
done

# Final message
dialog --title "Scan Complete" --msgbox "All drive scans complete. Please close this window." 6 50
