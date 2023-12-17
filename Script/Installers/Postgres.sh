#!/bin/bash
# Script to configure and start a Docker container with PostgreSQL

echo "PostgreSQL Docker configuration script."

# Prompt user for input with defaults
read -p "Enter the Docker image for PostgreSQL (e.g., postgres:latest): " IMAGE
IMAGE=${IMAGE:-"postgres:latest"}

read -p "Enter the name for the PostgreSQL container: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"postgres-container"}

read -p "Enter the port to expose PostgreSQL on (e.g., 5432): " PORT
PORT=${PORT:-5432}

read -p "Enter the database user: " DB_USER
DB_USER=${DB_USER:-"postgres"}

read -p "Enter the database password: " DB_PASS
DB_PASS=${DB_PASS:-"postgres"}

read -p "Enter the default database name: " DB_NAME
DB_NAME=${DB_NAME:-"postgres"}

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./postgres-docker"
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
      - POSTGRES_DB=$DB_NAME
      - POSTGRES_USER=$DB_USER
      - POSTGRES_PASSWORD=$DB_PASS
    volumes:
      - ./postgres-data:/var/lib/postgresql/data
    ports:
      - "$PORT:5432"
    restart: always
EOF

# Inform the user where the Docker compose file has been created
echo "Docker compose file created at: $COMPOSE_FILE"

# Start the PostgreSQL container using Docker Compose
echo "Starting n8n container named $CONTAINER_NAME."
docker compose -f "$COMPOSE_FILE" up -d
