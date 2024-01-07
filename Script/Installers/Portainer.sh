#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/portainer_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="portainer_install_run_"
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
# Script to setup and configure a Portainer Docker container based on user input

echo "Starting Portainer Docker configuration script."

# Prompt user for input with defaults
read -p "Enter the Docker image for Portainer (e.g., portainer/portainer-ce:latest): " IMAGE
IMAGE=${IMAGE:-"portainer/portainer-ce:latest"}

read -p "Enter the name for the Portainer container: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"portainer"}

read -p "Enter the port to expose Portainer on (e.g., 9000): " PORT
PORT=${PORT:-9000}

read -p "Enter the volume path for Portainer data (e.g., /portainer-data/): " DATA_PATH
DATA_PATH=${DATA_PATH:-"./portainer-data"}

read -p "Is this setup for Docker standalone or Docker Swarm? [standalone/swarm]: " DEPLOYMENT_TYPE
DEPLOYMENT_TYPE=${DEPLOYMENT_TYPE:-"standalone"}

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./portainer-docker"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Generate Docker compose file based on user input
if [ "$DEPLOYMENT_TYPE" = "swarm" ]; then
  # Docker Swarm deployment
  cat > "$COMPOSE_FILE" <<EOF
version: '3.8'
services:
  $CONTAINER_NAME:
    image: $IMAGE
    ports:
      - "$PORT:9000"
    volumes:
      - $DATA_PATH:/data
    deploy:
      mode: replicated
      replicas: 1
EOF
else
  # Docker standalone deployment
  cat > "$COMPOSE_FILE" <<EOF
version: '3'
services:
  $CONTAINER_NAME:
    image: $IMAGE
    container_name: $CONTAINER_NAME
    ports:
      - "$PORT:9000"
    volumes:
      - $DATA_PATH:/data
    restart: always
EOF
fi

# Inform the user where the Docker compose file has been created
echo "Docker compose file for $DEPLOYMENT_TYPE created at: $COMPOSE_FILE"

# Run the Docker Compose file to deploy the Portainer container
docker compose -f "$COMPOSE_FILE" up -d
