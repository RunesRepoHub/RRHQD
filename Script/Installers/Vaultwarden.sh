#!/bin/bash

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
    environment:
      - ADMIN_TOKEN=${ADMIN_TOKEN}
      - WEBSOCKET_ENABLED=${WEBSOCKET_ENABLED}
      - SIGNUPS_ALLOWED=${SIGNUPS_ALLOWED}
EOF

# Start the Docker container using docker-compose
docker compose up -d
