#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/docker_reset.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="docker_reset_run_"
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


# Script to stop all running Docker containers and delete all Docker objects

echo "Stopping all running Docker containers..."
sudo docker stop $(docker ps -aq)

echo "Removing all Docker containers..."
sudo docker rm $(docker ps -aq)

echo "Removing all Docker images..."
sudo docker rmi $(docker images -q) --force

echo "Removing all Docker volumes..."
sudo docker volume rm $(docker volume ls -q)

echo "Removing all Docker networks..."
sudo docker network rm $(docker network ls -q)

echo "Docker system pruning to remove any remaining unused data..."
sudo docker system prune -a --volumes --force

echo "Docker reset completed."
