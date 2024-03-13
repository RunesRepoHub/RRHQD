#!/bin/bash

LOG_DIR="$HOME/ACS/logs"
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

# Navigate to the Dockers directory
cd ~/ACS/Dockers

# Loop over each docker-compose file
for compose_file in *.yml; do
    # Bring the containers down
    sudo docker compose -f "$compose_file" down

    # Pull the latest images for the defined services
    sudo docker compose -f "$compose_file" pull

    # Bring the containers back up
    sudo docker compose -f "$compose_file" up -d
done

echo "All Docker containers have been updated."
