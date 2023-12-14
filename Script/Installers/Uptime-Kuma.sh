#!/bin/bash
clear 

source ~/RRHQD/Core/Core.sh

echo -e "${Green}Setup a Docker container for Uptime-Kuma${NC}"

# Prompt user for input with defaults
read -p "Enter the Docker image for Uptime-Kuma (e.g., louislam/uptime-kuma:1): " IMAGE
IMAGE=${IMAGE:-"louislam/uptime-kuma:1"}

read -p "Enter the name for the Uptime-Kuma container: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"uptime-kuma-container"}

read -p "Enter the port to expose Uptime-Kuma on (e.g., 3001): " PORT
PORT=${PORT:-3001}

read -p "Enter the path for Uptime-Kuma data (e.g., /kuma-data/): " DATA_PATH
DATA_PATH=${DATA_PATH:-./RRHQD-Dockers/kuma-data}

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./RRHQD-Dockers/compose-files"
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
  echo "      - \"$PORT:3001\""
  echo "    volumes:"
  echo "      - \"$DATA_PATH:/app/data\""
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
