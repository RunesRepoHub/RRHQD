#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/checkmk_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="checkmk_install_run_"
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

source ~/RRHQD/Core/Core.sh

# RRHQD/Script/Installers/CheckMK.sh
# Script to configure and start a Docker container running CheckMK

echo -e "${Green}Starting CheckMK Docker configuration script.${NC}"

# Prompt user for input with defaults

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"

read -p "Enter the Docker image for CheckMK (e.g., checkmk/check-mk-raw:latest): " IMAGE
IMAGE=${IMAGE:-"checkmk/check-mk-raw:latest"}

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"

read -p "Enter the name for the CheckMK container: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"checkmk-container"}

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"

read -p "Enter the port to expose CheckMK on (e.g., 8080): " PORT
PORT=${PORT:-8080}

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"

read -p "Enter the path for CheckMK data (e.g., /checkmk-data/): " DATA_PATH
DATA_PATH=${DATA_PATH:-./Data/checkmk-data}

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./checkmk-docker"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Create a Docker compose file with the user input
{
  echo "version: '3'"
  echo "services:"
  echo "  $CONTAINER_NAME:"
  echo "    image: $IMAGE"
  echo "    ports:"
  echo "      - \"$PORT:5000\""
  echo "    volumes:"
  echo "      - \"$DATA_PATH:/opt/omd/sites/checkmk\""
  echo "    restart: always"
} > "$COMPOSE_FILE"

# Inform the user where the Docker compose file has been created
echo -e "${Green}Docker compose file created at: $COMPOSE_FILE${NC}"

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