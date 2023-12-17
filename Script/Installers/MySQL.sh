#!/bin/bash
# Script to configure and start a Docker container with MySQL

echo "MySQL Docker configuration script."

# Prompt user for input with defaults
read -p "Enter the Docker image for MySQL (e.g., mysql:5.7): " IMAGE
IMAGE=${IMAGE:-"mysql:5.7"}

read -p "Enter the name for the MySQL container: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"mysql-container"}

read -p "Enter the port to expose MySQL on (e.g., 3306): " PORT
PORT=${PORT:-3306}

read -p "Enter the database user: " DB_USER
DB_USER=${DB_USER:-"root"}

read -p "Enter the database password: " DB_PASS
DB_PASS=${DB_PASS:-"mysql"}

read -p "Enter the default database name: " DB_NAME
DB_NAME=${DB_NAME:-"mydb"}

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./mysql-docker"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Create a Docker compose file with the user input
cat > "$COMPOSE_FILE" <<EOF
version: '3'
services:
  $CONTAINER_NAME:
    image: $IMAGE
    container_name: $CONTAINER_NAME
    environment:
      - MYSQL_DATABASE=$DB_NAME
      - MYSQL_USER=$DB_USER
      - MYSQL_PASSWORD=$DB_PASS
      - MYSQL_ROOT_PASSWORD=$DB_PASS
    volumes:
      - ./mysql-data:/var/lib/mysql
    ports:
      - "$PORT:3306"
    restart: always
EOF

# Inform the user where the Docker compose file has been created
echo "Docker compose file created at: $COMPOSE_FILE"

# Start the PostgreSQL container using Docker Compose
echo "Starting n8n container named $CONTAINER_NAME."
docker compose -f "$COMPOSE_FILE" up -d