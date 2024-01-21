#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/mediacms_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="mediacms_install_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file will be saved as $LOG_FILE"
}

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Installing dialog package for better user interface..."
    sudo apt-get update && sudo apt-get install dialog -y
fi

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

cd
# Script to configure and start a Docker container running MediaCMS

dialog --title "MediaCMS Configuration" --msgbox "Starting MediaCMS Docker configuration script." 6 50

# Use dialog to prompt user for input with defaults
IMAGE=$(dialog --title "MediaCMS Docker Image" --inputbox "Enter the Docker image for MediaCMS (e.g., mediacms-io/mediacms:latest):" 8 50 "mediacms-io/mediacms:latest" 3>&1 1>&2 2>&3 3>&-)
CONTAINER_NAME=$(dialog --title "MediaCMS Container Name" --inputbox "Enter the name for the MediaCMS container:" 8 50 "mediacms-container" 3>&1 1>&2 2>&3 3>&-)
PORT=$(dialog --title "MediaCMS Port" --inputbox "Enter the port to expose MediaCMS on (e.g., 8000):" 8 50 "8000" 3>&1 1>&2 2>&3 3>&-)
DATA_PATH=$(dialog --title "MediaCMS Data Path" --inputbox "Enter the path for MediaCMS data (e.g., /mediacms-data/):" 8 50 "./Data/mediacms-data" 3>&1 1>&2 2>&3 3>&-)

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./mediacms-docker"
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
  echo "      - \"$PORT:8000\""
  echo "    volumes:"
  echo "      - \"$DATA_PATH:/opt/mediacms/media\""
} > "$COMPOSE_FILE"

# Inform the user where the Docker compose file has been created
dialog --title "File Created" --msgbox "Docker compose file created at: $COMPOSE_FILE" 6 50

# Check if Docker is running and use sudo if the OS is ubuntu, zorin, linuxmint, or kali
OS_DISTRO=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')

check_docker() {
  if ! docker info >/dev/null 2>&1; then
    dialog --title "Error" --msgbox "Docker does not seem to be running. Please start Docker first and then re-run this script." 8 50
    exit 1
  fi
}

case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    sudo check_docker
    ;;
  *)
    check_docker
    ;;
esac

# Start the Docker container using docker-compose with or without sudo based on the OS
start_container() {
  if sudo docker compose -f "$COMPOSE_FILE" up -d; then
    dialog --title "Success" --msgbox "Docker container started successfully." 6 50
  else
    dialog --title "Error" --msgbox "Failed to start the Docker container. Please check the Docker compose file." 8 50
    exit 1
  fi
}

case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    sudo start_container
    ;;
  *)
    start_container
    ;;
esac

