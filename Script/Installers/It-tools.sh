#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/linkwarden_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="linkwarden_install_run_"
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

clear 

source ~/RRHQD/Core/Core.sh

# Prompt user for container name
read -p "Enter the name for the container (default: it-tools): " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"it-tools"}

# Prompt user for restart policy
read -p "Enter the restart policy for the container (default: unless-stopped): " RESTART_POLICY
RESTART_POLICY=${RESTART_POLICY:-"unless-stopped"}

# Prompt user for ports mapping
read -p "Enter the port mapping for the container (default: 8080:80): " PORT_MAPPING
PORT_MAPPING=${PORT_MAPPING:-"8080:80"}

docker run -d \
  --name "$CONTAINER_NAME" \
  --restart "$RESTART_POLICY" \
  -p "$PORT_MAPPING" \
  corentinth/it-tools:latest

# Check if the Docker container has started successfully
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    dialog --title "Success" --msgbox "The Docker container $CONTAINER_NAME has started successfully." 6 60
else
    dialog --title "Error" --msgbox "Failed to start the Docker container $CONTAINER_NAME. Please check the logs for details." 6 60
    exit 1
fi