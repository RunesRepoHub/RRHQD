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

# Generate a menu for user to select Docker containers to delete using dialog
dialog --clear --title "Select Docker containers to delete" --checklist "Use SPACE to select/deselect containers:" 15 60 4 \
$(mapfile -t containers < <(sudo docker ps -a --format "{{.Names}}"); IFS=$'\n'; for i in "${!containers[@]}"; do echo $((i+1)) "${containers[i]}" off; done) 2>"$OUTPUT"

# Read user's selections
if [[ $? -eq 0 ]]; then
    mapfile -t selections < "$OUTPUT"
    # Validate selections and prepare container names for deletion
    selected_containers=()
    for selection in "${selections[@]}"; do
        # Adjust selection index to match array index
        idx=$((selection - 1))
        if [[ idx -ge 0 && idx -lt ${#containers[@]} ]]; then
            selected_containers+=("${containers[idx]}")
        else
            echo "Invalid selection: $selection"
            dialog --msgbox "Invalid selection: $selection" 5 40
        fi
    done

    # Delete the chosen Docker containers
    for CONTAINER_NAME in "${selected_containers[@]}"; do
        if sudo docker rm -f "$CONTAINER_NAME"; then
            echo "$CONTAINER_NAME deleted successfully."
            dialog --msgbox "$CONTAINER_NAME deleted successfully." 5 40
        else
            echo "Failed to delete $CONTAINER_NAME."
            dialog --msgbox "Failed to delete $CONTAINER_NAME." 5 40
        fi
    done

    echo "All selected Docker containers have been deleted."
    dialog --msgbox "All selected Docker containers have been deleted." 5 60
else
    echo "Container deletion canceled."
    dialog --msgbox "Container deletion canceled." 5 40
fi

# Cleanup
rm -f "$OUTPUT"
