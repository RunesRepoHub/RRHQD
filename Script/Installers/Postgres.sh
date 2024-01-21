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

# Use dialog to create a more user-friendly interface for PostgreSQL Docker configuration

# Define default values
DEFAULT_IMAGE="postgres:latest"
DEFAULT_CONTAINER_NAME="postgres-container"
DEFAULT_PORT="5432"
DEFAULT_DB_USER="postgres"
DEFAULT_DB_PASS="postgres"
DEFAULT_DB_NAME="postgres"

# Use dialog to collect user input
IMAGE=$(dialog --stdout --title "PostgreSQL Docker Configuration" --inputbox "Enter the Docker image for PostgreSQL (e.g., postgres:latest):" 8 50 "$DEFAULT_IMAGE")
CONTAINER_NAME=$(dialog --stdout --title "PostgreSQL Docker Configuration" --inputbox "Enter the name for the PostgreSQL container:" 8 50 "$DEFAULT_CONTAINER_NAME")
PORT=$(dialog --stdout --title "PostgreSQL Docker Configuration" --inputbox "Enter the port to expose PostgreSQL on (e.g., 5432):" 8 50 "$DEFAULT_PORT")
DB_USER=$(dialog --stdout --title "PostgreSQL Docker Configuration" --inputbox "Enter the database user:" 8 50 "$DEFAULT_DB_USER")
DB_PASS=$(dialog --stdout --title "PostgreSQL Docker Configuration" --inputbox "Enter the database password:" 8 50 "$DEFAULT_DB_PASS")
DB_NAME=$(dialog --stdout --title "PostgreSQL Docker Configuration" --inputbox "Enter the default database name:" 8 50 "$DEFAULT_DB_NAME")

# Ensure dialog exit status is checked
if [ $? -ne 0 ]; then
  echo "User cancelled the dialog box."
  exit 1
fi

# Clear the dialog just in case
clear

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
dialog --msgbox "Docker compose file created at: $COMPOSE_FILE" 10 60

# Check if Docker is running and use sudo if the OS is ubuntu, zorin, linuxmint, or kali
OS_DISTRO=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    if ! sudo docker info >/dev/null 2>&1; then
      dialog --msgbox "Docker does not seem to be running, start it first with sudo and then re-run this script." 10 60
      exit 1
    fi
    ;;
  *)
    if ! docker info >/dev/null 2>&1; then
      dialog --msgbox "Docker does not seem to be running, start it first and then re-run this script." 10 60
      exit 1
    fi
    ;;
esac

# Start the Docker container using docker-compose with or without sudo based on the OS
case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    sudo docker compose -f "$COMPOSE_FILE" up -d && dialog --msgbox "Docker container started successfully." 10 60
    ;;
  *)
    docker compose -f "$COMPOSE_FILE" up -d && dialog --msgbox "Docker container started successfully." 10 60
    ;;
esac
