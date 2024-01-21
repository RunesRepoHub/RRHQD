#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/uptime_kuma_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="uptime_kuma_install_run_"
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

clear 

source ~/RRHQD/Core/Core.sh

cd

# Using dialog to create a more user-friendly interface
IMAGE=$(dialog --title "Docker Image" --inputbox "Enter the Docker image for Uptime-Kuma:" 10 60 "louislam/uptime-kuma:1" 3>&1 1>&2 2>&3 3>&-)
CONTAINER_NAME=$(dialog --title "Container Name" --inputbox "Enter the name for the Uptime-Kuma container:" 10 60 "uptime-kuma-container" 3>&1 1>&2 2>&3 3>&-)
PORT=$(dialog --title "Port" --inputbox "Enter the port to expose Uptime-Kuma on:" 10 60 "3001" 3>&1 1>&2 2>&3 3>&-)
DATA_PATH=$(dialog --title "Data Path" --inputbox "Enter the path for Uptime-Kuma data:" 10 60 "./Data/kuma-data" 3>&1 1>&2 2>&3 3>&-)

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./RRHQD-Dockers"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Create a Docker compose file with the user input inside the subfolder
{
  echo "version: '3'"
  echo "services:"
  echo "  $CONTAINER_NAME:"
  echo "    image: $IMAGE"
  echo "    ports:"
  echo "      - \"$PORT:3001\""
  echo "    volumes:"
  echo "      - \"$DATA_PATH:/app/data\""
} > "$COMPOSE_FILE"

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

# Start the Docker container using docker-compose with or without sudo based on the OS
case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    sudo docker compose -f "$COMPOSE_FILE" up -d
    ;;
  *)
    docker compose -f "$COMPOSE_FILE" up -d
    ;;
esac

