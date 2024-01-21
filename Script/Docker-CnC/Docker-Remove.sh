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

# Use dialog to create a more user-friendly interface for Docker container selection and removal

# Define the dialog exit status codes
: "${DIALOG_OK=0}"
: "${DIALOG_CANCEL=1}"
: "${DIALOG_ESC=255}"

# Function to generate a list of Docker containers for dialog
generate_container_list() {
  mapfile -t containers < <(sudo docker ps -a --format "{{.Names}}")
  local container_list=()
  for i in "${!containers[@]}"; do
    container_list+=("$((i+1))" "${containers[i]}" OFF)
  done
  echo "${container_list[@]}"
}

# Function to show dialog for container selection
select_containers() {
  local container_list=($(generate_container_list))
  dialog --checklist "Select Docker containers to delete:" 15 60 10 "${container_list[@]}" 2>"$OUTPUT"
}

# Function to delete selected containers
delete_selected_containers() {
  local selected_containers=($(<"$OUTPUT"))
  for id in "${selected_containers[@]}"; do
    local container_name="${containers[id-1]}"
    sudo docker rm -f "$container_name" && echo "$container_name deleted successfully." || echo "Failed to delete $container_name."
  done
}

# Define the output file for dialog selections
OUTPUT=/tmp/output.sh.$$

# Show container selection dialog
select_containers

# Check dialog's exit status
exit_status=$?
case $exit_status in
  $DIALOG_OK)
    delete_selected_containers
    echo "All selected Docker containers have been deleted."
    ;;
  $DIALOG_CANCEL)
    echo "Container deletion was canceled."
    ;;
  $DIALOG_ESC)
    echo "Container deletion was aborted."
    ;;
esac

# Cleanup
rm -f "$OUTPUT"

