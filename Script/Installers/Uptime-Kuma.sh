#!/bin/bash
clear 

source ~/RRHQD/Core/Core.sh

echo -e "${Green}Setup a Docker container for Uptime-Kuma${NC}"

# Prompt user for input
read -p "Enter the Docker image for Uptime-Kuma (e.g., louislam/uptime-kuma:1): " IMAGE
read -p "Enter the name for the Uptime-Kuma container: " CONTAINER_NAME
read -p "Enter the port to expose Uptime-Kuma on (e.g., 3001): " PORT
read -p "Enter the path for Uptime-Kuma data (e.g., /kuma-data/): " DATA_PATH

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
