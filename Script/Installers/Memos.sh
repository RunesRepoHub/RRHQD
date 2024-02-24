#!/bin/bash

SCRIPT_FILENAME=$(basename "$0")

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/"$SCRIPT_FILENAME"_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name=""$SCRIPT_FILENAME"_install_run_"
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

clear 

source ~/RRHQD/Core/Core.sh


echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter the container name: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"memos"}

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter the Docker image: " IMAGE
IMAGE=${IMAGE:-"neosmemo/memos:stable"}

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter the volume path: " VOLUME
VOLUME=${VOLUME:-"~/.memos/:/var/opt/memos"}

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter the port: " PORT
PORT=${PORT:-"5230"}

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./RRHQD-Dockers/Uptime-Kuma"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Create a Docker compose file with the user input inside the subfolder
{
  echo "version: '3.9'"
  echo "services:"
  echo "  container_name: $CONTAINER_NAME"
  echo "    image: $IMAGE"
  echo "    ports:"
  echo "      - \"$PORT:5230\""
  echo "    volumes:"
  echo "      - \"$DATA_PATH:/var/opt/memos\""
} > "$COMPOSE_FILE"

# Inform the user where the Docker compose file has been created
echo "Docker compose file created at: $COMPOSE_FILE"

# Start the Docker compose
docker compose -f "$COMPOSE_FILE" up -d

# Check if the Docker container has started successfully
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    dialog --title "Success" --msgbox "The Docker container $CONTAINER_NAME has started successfully." 6 60
else
    dialog --title "Error" --msgbox "Failed to start the Docker container $CONTAINER_NAME. Please check the logs for details." 6 60
    exit 1
fi
