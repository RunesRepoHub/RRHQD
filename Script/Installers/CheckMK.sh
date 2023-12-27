#!/bin/bash

source ~/RRHQD/Core/Core.sh

# RRHQD/Script/Installers/CheckMK.sh
# Script to configure and start a Docker container running CheckMK

echo -e "${Green}Starting CheckMK Docker configuration script.${NC}"

# Prompt user for input with defaults
read -p "Enter the Docker image for CheckMK (e.g., checkmk/check-mk-raw:latest): " IMAGE
IMAGE=${IMAGE:-"checkmk/check-mk-raw:latest"}

read -p "Enter the name for the CheckMK container: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"checkmk-container"}

read -p "Enter the port to expose CheckMK on (e.g., 8080): " PORT
PORT=${PORT:-8080}

read -p "Enter the path for CheckMK data (e.g., /checkmk-data/): " DATA_PATH
DATA_PATH=${DATA_PATH:-./checkmk-data}

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./checkmk-docker"
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
  echo "      - \"$PORT:5000\""
  echo "    volumes:"
  echo "      - \"$DATA_PATH:/opt/omd/sites/checkmk\""
  echo "    restart: always"
} > "$COMPOSE_FILE"

# Inform the user where the Docker compose file has been created
echo -e "${Green}Docker compose file created at: $COMPOSE_FILE${NC}"

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${Red}Docker does not seem to be running, start it first and then re-run this script.${NC}"
    exit 1
fi

# Start the Docker container using docker-compose
echo -e "${Green}Starting CheckMK Docker container...${NC}"
docker compose -f "$COMPOSE_FILE" up -d
