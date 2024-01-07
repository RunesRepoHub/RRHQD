#!/bin/bash
# Simple Bash script to spin up Docker containers from saved images

DOCKER_MIGRATION_PATH=/opt/docker_migration
LOG_DIR="$HOME/RRHQD/logs"
# Configuration
DOCKER_REMOTE_PATH=$DOCKER_MIGRATION_PATH     # Remote directory path for Docker images
LOG_FILE="$LOG_DIR/docker_import.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="docker_import_run_"
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

# Function to load Docker images and run containers from them
spin_up_docker() {
    local image_path=$1
    local image_name=$(basename "$image_path")
    local container_name="${image_name%_image.tar}"

    # Read user input for ports and volumes, if they are not provided as arguments
    local ports="${2:-}"
    if [[ -z "$ports" ]]; then
        read -p "Enter ports (format: 'host_port:container_port', separate multiple with spaces): " ports
    fi
    local volumes="${3:-}"
    if [[ -z "$volumes" ]]; then
        read -p "Enter volumes (format: 'host_volume:container_volume', separate multiple with spaces): " volumes
    fi

    echo "Loading image $image_name" | tee -a "$LOG_FILE"
    docker load -i "$image_path" | tee -a "$LOG_FILE"

    echo "Starting container from $image_name" | tee -a "$LOG_FILE"
    docker run -d --name "$container_name" $ports $volumes "${container_name}_image" | tee -a "$LOG_FILE"
}

# Main script execution
echo "Starting Docker spin up at $(date)" | tee -a "$LOG_FILE"

# List available Docker image files
echo "Available Docker image files:" | tee -a "$LOG_FILE"
ls "$DOCKER_REMOTE_PATH"/*.tar | tee -a "$LOG_FILE"

# Create an array to hold paths of Docker images
images=("$DOCKER_REMOTE_PATH"/*.tar)

# Display options for user to pick
echo "Please select an image to spin up by entering the corresponding number:"
select image_path in "${images[@]}"; do
    if [[ -n "$image_path" ]]; then
        echo "You have selected image: $image_path"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done
spin_up_docker "$image_path"

echo "Docker spin up completed at $(date)" | tee -a "$LOG_FILE"

# Check if dialog command is available before attempting to use it
if command -v dialog &>/dev/null; then
    dialog --title "Import Success" --msgbox "The Docker image has been successfully imported and the container is running." 6 50
else
    echo "The Docker image has been successfully imported and the container is running."
fi
