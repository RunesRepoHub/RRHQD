#!/bin/bash
# Script to configure and start a Docker container running MediaCMS

echo "Starting MediaCMS Docker configuration script."

# Prompt user for input with defaults
read -p "Enter the Docker image for MediaCMS (e.g., mediacms-io/mediacms:latest): " IMAGE
IMAGE=${IMAGE:-"mediacms-io/mediacms:latest"}

read -p "Enter the name for the MediaCMS container: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"mediacms-container"}

read -p "Enter the port to expose MediaCMS on (e.g., 8000): " PORT
PORT=${PORT:-8000}

read -p "Enter the path for MediaCMS data (e.g., /mediacms-data/): " DATA_PATH
DATA_PATH=${DATA_PATH:-./mediacms-data}

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./mediacms-docker"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Create a Docker compose file with the user input
{
  echo "version: '3'"
  echo "services:"
  echo "  $CONTAINER_NAME:"
  echo "    image: $IMAGE"
  echo "    ports:"
  echo "      - \"$PORT:8000\""
  echo "    volumes:"
  echo "      - \"$DATA_PATH:/opt/mediacms/media\""
} > "$COMPOSE_FILE"

# Inform the user where the Docker compose file has been created
echo "Docker compose file created at: $COMPOSE_FILE"

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "Docker does not seem to be running, start it first and then re-run this script."
    exit 1
fi

# Start the Docker container using docker-compose
echo "Starting MediaCMS Docker container..."
docker compose -f "$COMPOSE_FILE" up -d
