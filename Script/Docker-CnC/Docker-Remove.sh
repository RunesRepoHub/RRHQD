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

# Define the input file for dialog selections
INPUT=/tmp/menu.sh.$$
OUTPUT=/tmp/output.sh.$$

# Function to list and select Docker containers for deletion
function show_docker_delete_menu() {
    local containers=($(docker ps -a --format "{{.Names}}"))
    local options=()

    for container in "${containers[@]}"; do
        options+=("$container" "" OFF)
    done

    dialog --clear \
           --backtitle "Docker Management" \
           --title "Select Docker Containers to Delete" \
           --checklist "Use SPACE to select containers to delete:" 15 60 6 \
           "${options[@]}" 2>"${OUTPUT}"

    if [ $? -eq 0 ]; then
        # When user presses 'OK', containers to delete are stored in $OUTPUT
        local selected_containers=($(<"${OUTPUT}"))
        for container in "${selected_containers[@]}"; do
            docker rm -f "$container"
        done
    fi
}

# Ensure the temp files are removed upon script termination
trap "rm -f $INPUT $OUTPUT" 0 1 2 5 15

# Show the menu
show_docker_delete_menu
