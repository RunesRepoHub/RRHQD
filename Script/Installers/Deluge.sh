#!/bin/bash

# Set variables for Docker image and container names
DEFAULT_IMAGE="lscr.io/linuxserver/deluge:latest"
DEFAULT_CONTAINER_NAME="deluge"
DOCKER_ROOT_FOLDER_DEFAULT=~/deluge/configs # Replace with the default path for Docker configs
DOCKER_DOWNLOAD_FOLDER_DEFAULT=~/deluge/downloads # Replace with the default path for downloads

# Function to prompt the user for input with a default value
prompt_for_input() {
    local prompt_message=$1
    local default_value=$2
    read -p "$prompt_message [$default_value]: " input_value
    echo "${input_value:-$default_value}"
}

# Ask user for necessary environment variables
echo "Setting up Deluge Docker container."
IMAGE=$(prompt_for_input "Enter Docker image for Deluge" $DEFAULT_IMAGE)
CONTAINER_NAME=$(prompt_for_input "Enter container name" $DEFAULT_CONTAINER_NAME)
DOCKER_ROOT_FOLDER=$(prompt_for_input "Enter Docker root folder for configs" $DOCKER_ROOT_FOLDER_DEFAULT)
DOCKER_DOWNLOAD_FOLDER=$(prompt_for_input "Enter folder for downloads" $DOCKER_DOWNLOAD_FOLDER_DEFAULT)

# Create a Docker Compose file for Deluge
cat > deluge-compose.yml <<EOF
version: '3'
services:
  $CONTAINER_NAME:
    image: $IMAGE
    container_name: $CONTAINER_NAME
    network_mode: bridge
    mem_limit: 2g
    environment:
      - PUID=\$(id -u)
      - PGID=\$(id -g)
      - UMASK=002
      - TZ=\$(date +%Z)
      - DELUGE_LOGLEVEL=error
    volumes:
      - $DOCKER_ROOT_FOLDER/$CONTAINER_NAME:/config
      - $DOCKER_DOWNLOAD_FOLDER:/downloads
    ports:
      - "8112:8112"
      - "6881:6881"
      - "6881:6881/udp"
    restart: unless-stopped
EOF

# Inform the user that the Docker Compose file has been created
echo "Docker Compose file for Deluge has been created."

# Run Docker Compose to start the container
echo "Starting Deluge container..."
docker-compose -f deluge-compose.yml up -d

# Check if the Docker container(s) have started successfully
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    dialog --title "Success" --msgbox "The Docker container $CONTAINER_NAME has started successfully." 6 60
else
    dialog --title "Error" --msgbox "Failed to start the Docker container $CONTAINER_NAME. Please check the logs for details." 6 60
    exit 1
fi
