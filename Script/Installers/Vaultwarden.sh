#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/vaultwarden_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="vaultwarden_install_run_"
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

echo -e "${Green}Setup a Docker container for Vaultwarden${NC}"

# Prompt user for input with defaults
read -p "Enter the Docker image for Vaultwarden (e.g., vaultwarden/server:latest): " IMAGE
IMAGE=${IMAGE:-vaultwarden/server:latest}

read -p "Enter the name for the Vaultwarden container: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-vaultwarden}

read -p "Enter the port to expose Vaultwarden on (e.g., 80): " PORT
PORT=${PORT:-80}

read -p "Enter the path for Vaultwarden data (e.g., /vw-data/): " DATA_PATH
DATA_PATH=${DATA_PATH:-./RRHQD-Dockers/vw-data}

read -p "Enter the admin token for Vaultwarden: " ADMIN_TOKEN
ADMIN_TOKEN=${ADMIN_TOKEN:-$(openssl rand -base64 32)}

read -p "Allow signups? (y/n): " SIGNUPS_ALLOWED
SIGNUPS_ALLOWED=${SIGNUPS_ALLOWED:-y}

read -p "Enable WebSockets? (y/n): " WEBSOCKET_ENABLED
WEBSOCKET_ENABLED=${WEBSOCKET_ENABLED:-y}

# Convert y/n input to true/false for environment variables
SIGNUPS_ALLOWED=$( [[ "$SIGNUPS_ALLOWED" == "y" ]] && echo "true" || echo "false" )
WEBSOCKET_ENABLED=$( [[ "$WEBSOCKET_ENABLED" == "y" ]] && echo "true" || echo "false" )

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./RRHQD-Dockers"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Create a Docker compose file with the user input inside the subfolder
{
  echo "version: '3'"
  echo "services:"
  echo "  $CONTAINER_NAME:"
  echo "    image: $IMAGE"
  echo "    ports:"
  echo "      - \"$PORT:80\""
  echo "    volumes:"
  echo "      - \"$DATA_PATH:/data\""
  echo "    environment:"
  echo "      - ADMIN_TOKEN=${ADMIN_TOKEN}"
  echo "      - WEBSOCKET_ENABLED=${WEBSOCKET_ENABLED}"
  echo "      - SIGNUPS_ALLOWED=${SIGNUPS_ALLOWED}"
} > "$COMPOSE_FILE"

# Inform the user where the Docker compose file has been created
echo "Docker compose file created at: $COMPOSE_FILE"

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "Docker does not seem to be running, start it first and then re-run this script."
    exit 1
fi

# Start the Docker container using docker-compose
docker compose -f "$COMPOSE_FILE" up -d

