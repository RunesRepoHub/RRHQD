#!/bin/bash
# Simple Bash script to spin up Docker containers from saved images

DOCKER_MIGRATION_PATH=/opt/docker_migration
LOG_DIR="$HOME/RRHQD/logs"
# Configuration
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

# List new Docker images in the migration path
echo "Available Docker images in $DOCKER_MIGRATION_PATH:"
ls "$DOCKER_MIGRATION_PATH" | grep '_image.tar$'

# Prompt user for the Docker image to load
read -p "Enter the Docker image file name to load: " DOCKER_IMAGE_FILE

# Load the Docker image
docker load -i "$DOCKER_MIGRATION_PATH/$DOCKER_IMAGE_FILE"
if [ $? -ne 0 ]; then
  echo "Failed to load Docker image."
  exit 1
fi
echo "Docker image loaded successfully."

# Extract the container name from the image file name
CONTAINER_NAME=$(basename "$DOCKER_IMAGE_FILE" "_image.tar")

# Run the Docker container
read -p "Enter the port mappings (format: 80:80): " PORT_MAPPINGS
read -p "Enter the volume mappings (format: /host/path:/container/path): " VOLUME_MAPPINGS
docker run -d --name "$CONTAINER_NAME" -p $PORT_MAPPINGS -v $VOLUME_MAPPINGS "$CONTAINER_NAME"
if [ $? -ne 0 ]; then
  echo "Failed to run Docker container."
  exit 1
fi

# Check if dialog command is available before attempting to use it
if command -v dialog &>/dev/null; then
    dialog --title "Import Success" --msgbox "The Docker image has been successfully imported and the container is running." 6 50
else
    echo "The Docker image has been successfully imported and the container is running."
fi
