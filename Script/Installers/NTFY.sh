#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/ntfy_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="ntfy_install_run_"
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

cd
# Script to configure and start a Docker container running NTFY

echo "Starting NTFY Docker configuration script."

# Prompt user for input with defaults
read -p "Enter the Docker image for NTFY (e.g., binwiederhier/ntfy:latest): " IMAGE
IMAGE=${IMAGE:-"binwiederhier/ntfy:latest"}

read -p "Enter the name for the NTFY container: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"ntfy-container"}

read -p "Enter the port to expose NTFY on (e.g., 8080): " PORT
PORT=${PORT:-8080}

read -p "Enter the path for NTFY data (e.g., /ntfy-data/): " DATA_PATH
DATA_PATH=${DATA_PATH:-./Data/ntfy-data}

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./ntfy-docker"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Create a Docker compose file with the user input
{
echo "version: '3'"
echo "services:"
echo "  $CONTAINER_NAME:"
echo "    image: $IMAGE"
echo "    container_name: $CONTAINER_NAME"
echo "    command:"
echo "      - serve"
echo "    environment:"
echo "      - TZ=UTC"
echo "    volumes:"
echo "      - $DATA_PATH:/var/cache/ntfy"
echo "      - /etc/ntfy:/etc/ntfy"
echo "    ports:"
echo "      - \"$PORT:80\""
echo "    restart: always"
} > "$COMPOSE_FILE"

# Inform the user where the Docker compose file has been created
echo "Docker compose file created at: $COMPOSE_FILE"

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "Docker does not seem to be running, start it first and then re-run this script."
    exit 1
fi

# Starting the NTFY container using Docker Compose
echo "Starting NTFY container named $CONTAINER_NAME."
docker compose -f "$COMPOSE_FILE" up -d
