#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/docker_stop.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="docker_stop_run_"
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

# Stop all running Docker containers

dialog --title "Stopping Docker containers" --infobox "Stopping all running Docker containers..." 5 70
container_ids=$(sudo docker ps -q)
if [ -n "$container_ids" ]; then
    sudo docker stop $container_ids
    dialog --title "Docker containers stopped" --msgbox "All Docker containers have been stopped." 5 70
else
    dialog --title "No containers to stop" --msgbox "There are no running Docker containers to stop." 5 70
fi
