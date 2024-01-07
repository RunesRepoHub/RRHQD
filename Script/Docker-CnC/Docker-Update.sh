#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/docker_update.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="docker_update_run_"
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

# RRHQD/Script/Docker-CnC/Docker-Update.sh

# Function to list all running Docker containers
list_containers() {
  docker ps --format "{{.Names}}" | nl -w2 -s ') '
}

# Function to get the image of a specific Docker container
get_container_image() {
  docker inspect --format='{{.Config.Image}}' "$1"
}

# Function to update the Docker container
update_container() {
  local container_name="$1"
  local container_image="$(get_container_image "$container_name")"

  echo "Updating $container_name with image $container_image..."
  docker pull "$container_image" && \
  docker stop "$container_name" && \
  docker rm "$container_name" && \
  docker run -d --name "$container_name" "$container_image"
}

# Main menu
echo "Select Docker containers to update:"
list_containers
read -p "Enter the numbers of the containers to update (separated by spaces): " input

# Split the input into an array
IFS=' ' read -r -a selections <<< "$input"

# Loop over the selections and update the corresponding containers
for selection in "${selections[@]}"; do
  # Fetch the container name by its number
  container_name=$(list_containers | sed "${selection}q;d" | awk '{print $2}')

  # Update the container
  if [ -n "$container_name" ]; then
    update_container "$container_name"
  else
    echo "Invalid selection: $selection"
  fi
done

echo "Update process completed."
