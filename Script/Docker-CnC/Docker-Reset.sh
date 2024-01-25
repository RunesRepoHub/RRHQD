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

dialog --title "Docker Reset" --infobox "Stopping all running Docker containers..." 5 70
sudo docker stop $(docker ps -aq)
sleep 1

dialog --title "Docker Reset" --infobox "Removing all Docker containers..." 5 70
sudo docker rm $(docker ps -aq)
sleep 1

dialog --title "Docker Reset" --infobox "Removing all Docker images..." 5 70
sudo docker rmi $(docker images -q) --force
sleep 1

dialog --title "Docker Reset" --infobox "Removing all Docker volumes..." 5 70
sudo docker volume rm $(docker volume ls -q)
sleep 1

dialog --title "Docker Reset" --infobox "Removing all Docker networks..." 5 70
sudo docker network rm $(docker network ls -q)
sleep 1

dialog --title "Docker Reset" --infobox "Performing Docker system prune to remove any remaining unused data..." 5 70
sudo docker system prune -a --volumes --force
sleep 1

dialog --title "Docker Reset" --msgbox "Docker reset completed." 5 70

