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

# Create a Docker compose file with the user input
cat > docker-compose.yml <<EOF
version: '3'
services:
  $CONTAINER_NAME:
    image: $IMAGE
    ports:
      - "$PORT:3001"
    volumes:
      - $DATA_PATH:/app/data
EOF

# Start the Docker container using docker-compose
docker compose up -d
