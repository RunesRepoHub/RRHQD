#!/bin/bash

# Set variables for Docker image and container names
IMAGE="ghost:latest"
CONTAINER_NAME="ghost_blog"
PORTS=2368
GHOST_CONTENT_FOLDER=./RRHQD-Dockers/ghost/content # Replace with the default path for Ghost content
MYSQL_FOLDER=./RRHQD-Dockers/ghost/mysql

# Function to prompt the user for input with a default value
prompt_for_input() {
    local prompt_message=$1
    local default_value=$2
    read -p "$prompt_message [$default_value]: " input_value
    echo "${input_value:-$default_value}"
}

# Ask user for necessary environment variables
echo "Setting up Ghost Docker container."
IMAGE=$(prompt_for_input "Enter Docker image for Ghost" $IMAGE)
CONTAINER_NAME=$(prompt_for_input "Enter container name" $CONTAINER_NAME)
URL=$(prompt_for_input "Enter URL for Ghost" "https://blog.yourdomain.com")
PORTS=$(prompt_for_input "Enter port for Ghost" 2368)
GHOST_CONTENT_FOLDER=$(prompt_for_input "Enter Ghost content folder" $GHOST_CONTENT_FOLDER)
MYSQL_PASSWORD=$(prompt_for_input "Enter MySQL password")
MYSQL_ROOT_PASSWORD=$(prompt_for_input "Enter MySQL root password")
MYSQL_FOLDER=$(prompt_for_input "Enter MySQL folder" $MYSQL_FOLDER)

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./RRHQD-Dockers/Ghost"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Create a Docker Compose file for Ghost
cat > $COMPOSE_FILE <<EOF
version: "3.3"
services:
  $CONTAINER_NAME:
    image: $IMAGE
    restart: always
    ports:
      - "$PORTS:2368"
    depends_on:
      - db
    environment:
      url: $URL
      database__client: mysql
      database__connection__host: db
      database__connection__user: ghost
      database__connection__password: $MYSQL_PASSWORD
      database__connection__database: ghostdb
    volumes:
      - $GHOST_CONTENT_FOLDER:/var/lib/ghost/content

  db:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: RuneProduction
      MYSQL_USER: ghost
      MYSQL_PASSWORD: $MYSQL_PASSWORD
      MYSQL_DATABASE: ghostdb
    volumes:
      - $MYSQL_FOLDER:/var/lib/mysql
EOF

# Inform the user that the Docker Compose file has been created
echo "Docker Compose file for Ghost has been created."

# Run Docker Compose to start the container
echo "Starting Ghost container..."
docker compose -f ghost-compose.yml up -d

# Check if the Docker container(s) have started successfully
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    dialog --title "Success" --msgbox "The Docker container $CONTAINER_NAME has started successfully." 6 60
else
    dialog --title "Error" --msgbox "Failed to start the Docker container $CONTAINER_NAME. Please check the logs for details." 6 60
    exit 1
fi
