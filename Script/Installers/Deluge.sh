#!/bin/bash

source ~/RRHQD/Core/Core.sh

# Ask user for necessary environment variables
echo -e "${Green}Setting up Deluge Docker container.${NC}"

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter Docker image for Deluge (e.g., lscr.io/linuxserver/deluge:latest): " IMAGE
IMAGE=${IMAGE:-"lscr.io/linuxserver/deluge:latest"}

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter container name: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"deluge-container"}

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter Deluge root folder: " DOCKER_ROOT_FOLDER
DOCKER_ROOT_FOLDER=${DOCKER_ROOT_FOLDER:-./Data/config}

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter download folder: " DOCKER_DOWNLOAD_FOLDER
DOCKER_DOWNLOAD_FOLDER=${DOCKER_DOWNLOAD_FOLDER:-./Data/downloads}

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./RRHQD-Dockers/Deluge"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

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
    restart: always
EOF

# Inform the user that the Docker Compose file has been created
echo "Docker Compose file for Deluge has been created."

# Run Docker Compose to start the container
echo "Starting Deluge container..."
docker compose -f deluge-compose.yml up -d

# Check if the Docker container(s) have started successfully
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    dialog --title "Success" --msgbox "The Docker container $CONTAINER_NAME has started successfully." 6 60
else
    dialog --title "Error" --msgbox "Failed to start the Docker container $CONTAINER_NAME. Please check the logs for details." 6 60
    exit 1
fi
