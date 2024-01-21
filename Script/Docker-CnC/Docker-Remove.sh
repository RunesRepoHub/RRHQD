#!/bin/bash

# Configuration for logging
LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/docker_remove.log"  # Log file location for Docker removal

# Function to increment log file name for Docker removal
increment_log_file_name() {
  local log_file_base_name="docker_remove_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file for Docker removal will be saved as $LOG_FILE"
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Refactored Code Block

# Function to delete selected containers with improved error handling
delete_selected_containers() {
  local selected_containers=()
  mapfile -t selected_containers < "$OUTPUT"
  local container_name

  for id in "${selected_containers[@]}"; do
    if [[ $id =~ ^[0-9]+$ ]] && [ "$id" -le "${#containers[@]}" ]; then
      container_name="${containers[id-1]}"
      if sudo docker rm -f "$container_name" > /dev/null 2>&1; then
        echo "$container_name deleted successfully."
      else
        echo "Failed to delete $container_name."
      fi
    else
      echo "Invalid container selection: $id"
    fi
  done
}

# Main function for container removal with improved error handling
remove_containers_main() {
  select_containers
  local exit_status=$?
  
  if [ $exit_status -eq $DIALOG_OK ]; then
    delete_selected_containers
    echo "All selected Docker containers have been deleted."
  elif [ $exit_status -eq $DIALOG_CANCEL ]; then
    echo "Container deletion was canceled."
  elif [ $exit_status -eq $DIALOG_ESC ]; then
    echo "Container deletion was aborted."
  else
    echo "Unknown error occurred."
  fi
}

# Ensure the containers array is available globally or passed to functions that require it
containers=()
mapfile -t containers < <(sudo docker ps -a --format "{{.Names}}")

# Run the main function
remove_containers_main

# Cleanup
rm -f "$OUTPUT"

