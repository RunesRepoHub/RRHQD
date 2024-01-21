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

# Function to present a dialog for container selection and write output to a file
select_containers() {
  # Fetch the list of containers and format it as "ID Name" pairs
  local container_list=()
  while IFS= read -r line; do
    container_list+=("$line" "off")
  done < <(sudo docker ps -a --format '{{.ID}} {{.Names}}')

  # Use the container list to create a dialog checklist
  dialog --checklist "Select containers to delete:" 20 60 15 "${container_list[@]}" 2> "$OUTPUT"
}

# Function to delete selected containers using dialog for improved user interaction
delete_selected_containers() {
  local selected_ids=()
  mapfile -t selected_ids < "$OUTPUT"
  local container_id container_name

  for container_id in "${selected_ids[@]}"; do
    container_name=$(sudo docker ps -a --format '{{.ID}} {{.Names}}' | awk -v id="$container_id" '$1 == id {print $2}')
    if sudo docker rm -f "$container_name" > /dev/null 2>&1; then
      dialog --msgbox "$container_name deleted successfully." 6 40
    else
      dialog --msgbox "Failed to delete $container_name." 6 40
    fi
  done
}

# Main function for container removal with dialog-based user interface
remove_containers_main() {
  select_containers
  local exit_status=$?

  if [ $exit_status -eq $DIALOG_OK ]; then
    delete_selected_containers
    dialog --msgbox "All selected Docker containers have been deleted." 6 40
  elif [ $exit_status -eq $DIALOG_CANCEL ]; then
    dialog --msgbox "Container deletion was canceled." 6 40
  elif [ $exit_status -eq $DIALOG_ESC ]; then
    dialog --msgbox "Container deletion was aborted." 6 40
  else
    dialog --msgbox "Unknown error occurred." 6 40
  fi
}

