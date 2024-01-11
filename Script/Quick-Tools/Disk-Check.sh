#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/disk_check.log"

increment_log_file_name() {
  local log_file_base_name="disk_check_run_"
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

# Ensure all dependencies for disk checking are installed
ensure_dependencies_installed() {
  local dependencies=(smartmontools e2fsprogs dialog)
  local missing_dependencies=()

  for dep in "${dependencies[@]}"; do
    if ! command -v $dep &> /dev/null; then
      missing_dependencies+=($dep)
    fi
  done

  if [ ${#missing_dependencies[@]} -ne 0 ]; then
    echo "The following dependencies are missing: ${missing_dependencies[*]}"
    echo "Attempting to install missing dependencies..."
    sudo apt-get update && sudo apt-get install -y "${missing_dependencies[@]}"
  else
    echo "All necessary dependencies are already installed."
  fi
}

ensure_dependencies_installed

# Function to perform a full scan on a disk using smartctl and badblocks with dialog for user interaction
perform_full_scan() {
  local disk=$1
  dialog --title "Scan Initiated" --infobox "Starting full scan on $disk..." 5 60
  sleep 2

  # Check S.M.A.R.T. status
  if ! smartctl -H /dev/"$disk"; then
    dialog --title "S.M.A.R.T. Status" --msgbox "S.M.A.R.T. status check failed for /dev/$disk" 5 60
    return 1
  fi

  # Run a short S.M.A.R.T. self-test
  dialog --title "S.M.A.R.T. Self-Test" --infobox "Running short S.M.A.R.T. self-test on $disk..." 5 60
  if ! smartctl -t short /dev/"$disk"; then
    dialog --title "S.M.A.R.T. Self-Test" --msgbox "Short S.M.A.R.T. self-test failed for /dev/$disk" 5 60
    return 1
  fi

  # Inform user to wait for the short test to complete
  dialog --title "Please Wait" --infobox "Waiting 2 minutes for the short S.M.A.R.T. self-test to complete on $disk..." 5 60
  sleep 2m

  # Check self-test logs
  if ! smartctl -l selftest /dev/"$disk"; then
    dialog --title "Self-Test Logs" --msgbox "Self-test log check failed for /dev/$disk" 5 60
    return 1
  fi

  # Check for bad sectors
  if ! badblocks -sv /dev/"$disk"; then
    dialog --title "Bad Sectors" --msgbox "Bad sectors found on /dev/$disk" 5 60
    return 1
  fi

  dialog --title "Scan Completed" --msgbox "Full scan completed successfully for /dev/$disk." 5 60
}

# List all block devices without partitions
disks=$(lsblk -d -n -o name,type | awk '$2 == "disk" {print $1}')

# Iterate through each disk and perform a full scan using dialog
for disk in $disks; do
  perform_full_scan "$disk"
done
