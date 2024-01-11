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

# Function to perform a full scan on a disk using smartctl and badblocks
perform_full_scan() {
  local disk=$1
  echo "Starting full scan on $disk..."

  # Check S.M.A.R.T. status
  echo "Checking S.M.A.R.T. status..."
  smartctl -H /dev/"$disk" || { echo "S.M.A.R.T. status check failed for /dev/$disk"; return 1; }

  # Run a short S.M.A.R.T. self-test
  echo "Running short S.M.A.R.T. self-test..."
  smartctl -t short /dev/"$disk" || { echo "Short S.M.A.R.T. self-test failed for /dev/$disk"; return 1; }

  # Wait for the short test to complete
  sleep 2m

  # Check self-test logs
  echo "Checking self-test logs..."
  smartctl -l selftest /dev/"$disk" || { echo "Self-test log check failed for /dev/$disk"; return 1; }

  # Check for bad sectors
  echo "Checking for bad sectors..."
  badblocks -sv /dev/"$disk" || { echo "Bad sectors found on /dev/$disk"; return 1; }

  echo "Full scan completed successfully for /dev/$disk."
}

# List all block devices without partitions
disks=$(lsblk -d -n -o name,type | awk '$2 == "disk" {print $1}')

# Iterate through each disk and perform a full scan
for disk in $disks; do
  perform_full_scan "$disk"
done
