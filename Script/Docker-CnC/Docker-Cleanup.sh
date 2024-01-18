#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/docker_cleanup.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="docker_cleanup_run_"
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

# Script to cleanup unused Docker resources including images, volumes, and networks

echo "Initiating Docker cleanup process..."


# Remove all unused images, not just dangling ones
sudo docker image prune -a --force

# Remove all unused volumes
sudo docker volume prune --force

# Remove all unused networks
sudo docker network prune --force

echo "Docker cleanup completed."
