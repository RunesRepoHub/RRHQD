#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/postgres_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="postgres_install_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file will be saved as $LOG_FILE"
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

cd 
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

# Check if Docker is running and use sudo if the OS is ubuntu, zorin, linuxmint, or kali
OS_DISTRO=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    if ! sudo docker info >/dev/null 2>&1; then
      echo "Docker does not seem to be running, start it first with sudo and then re-run this script."
      exit 1
    fi
    ;;
  *)
    if ! docker info >/dev/null 2>&1; then
      echo "Docker does not seem to be running, start it first and then re-run this script."
      exit 1
    fi
    ;;
esac

# Determine the OS distribution
OS_DISTRO=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')

# Start the Docker container using docker-compose with or without sudo based on the OS
case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    sudo docker compose -f "$COMPOSE_FILE" up -d
    ;;
  *)
    docker compose -f "$COMPOSE_FILE" up -d
    ;;
esac