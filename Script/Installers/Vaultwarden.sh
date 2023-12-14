#!/bin/bash

source ./RRHQD/Core/Core.sh

echo -e "${Green}Setup a Docker container for Vaultwarden${NC}"

# Prompt user for input
read -p "Enter the Docker image for Vaultwarden (e.g., vaultwarden/server:latest): " IMAGE
read -p "Enter the name for the Vaultwarden container: " CONTAINER_NAME
read -p "Enter the port to expose Vaultwarden on (e.g., 80): " PORT
read -p "Enter the path for Vaultwarden data (e.g., /vw-data/): " DATA_PATH

# Create a Docker compose file with the user input
cat > docker-compose.yml <<EOF
version: '3'
services:
  $CONTAINER_NAME:
    image: $IMAGE
    ports:
      - "$PORT:80"
    volumes:
      - $DATA_PATH:/data
EOF

# Start the Docker container using docker-compose
docker-compose up -d
