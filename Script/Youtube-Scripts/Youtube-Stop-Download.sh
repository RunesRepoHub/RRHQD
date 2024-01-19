#!/bin/bash

LOG_DIR="$HOME/ACS/logs"
LOG_FILE="$LOG_DIR/docker_stop.log"  # Log file location

increment_log_file_name() {
  local log_file_base_name="docker_stop_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file will be saved as $LOG_FILE"
}

mkdir -p "$LOG_DIR"
increment_log_file_name
exec > >(tee -a "$LOG_FILE") 2>&1

# Stop and remove any docker with the image mikenye/youtube-dl

source ~/ACS/ACSF-Scripts/Core.sh


echo -e "${Green}Stopping all mikenye/youtube-dl containers...${NC}"
echo -e "${Green}This may take a while...${NC}"

# Get the container IDs
container_ids=$(sudo docker ps -q --filter ancestor=mikenye/youtube-dl)

# Send a stop command to all containers
for container_id in $container_ids; do
    sudo docker stop $container_id
done