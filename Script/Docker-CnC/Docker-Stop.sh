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

# Generate a menu for user to select Docker containers to stop
echo "Available Docker containers:"
mapfile -t containers < <(sudo docker ps --format "{{.Names}}")  # List only running containers
for i in "${!containers[@]}"; do
    echo "$((i+1))) ${containers[i]}"
done

# Ask user to select containers
echo "Enter the numbers of the Docker containers to stop (separated by space):"
read -r -a selections

# Validate selections and prepare container names
selected_containers=()
for selection in "${selections[@]}"; do
    # Adjust selection index to match array index
    idx=$((selection - 1))
    if [[ idx -ge 0 && idx -lt ${#containers[@]} ]]; then
        selected_containers+=("${containers[idx]}")
    else
        echo "Invalid selection: $selection"
    fi
done

# Stop the chosen Docker containers
for CONTAINER_NAME in "${selected_containers[@]}"; do
    sudo docker stop "$CONTAINER_NAME" && echo "$CONTAINER_NAME stopped successfully." || echo "Failed to stop $CONTAINER_NAME."
done

echo "All selected Docker containers have been stopped."
