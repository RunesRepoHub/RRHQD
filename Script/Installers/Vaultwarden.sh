#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/vaultwarden_install.log"

increment_log_file_name() {
  local log_file_base_name="vaultwarden_install_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file will be saved as $LOG_FILE"
}

mkdir -p "$LOG_DIR"
increment_log_file_name
exec > >(tee -a "$LOG_FILE") 2>&1

cd
clear
source ~/RRHQD/Core/Core.sh

# Check if dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "dialog not found, please install it first."
    exit 1
fi

# Use dialog to make the script more user-friendly
IMAGE=$(dialog --title "Vaultwarden Docker image" --inputbox "Enter the Docker image for Vaultwarden (e.g., vaultwarden/server:latest):" 8 50 "vaultwarden/server:latest" 3>&1 1>&2 2>&3 3>&-)
CONTAINER_NAME=$(dialog --title "Container name" --inputbox "Enter the name for the Vaultwarden container:" 8 50 "vaultwarden" 3>&1 1>&2 2>&3 3>&-)
PORT=$(dialog --title "Port configuration" --inputbox "Enter the port to expose Vaultwarden on (e.g., 80):" 8 50 "80" 3>&1 1>&2 2>&3 3>&-)
DATA_PATH=$(dialog --title "Data path" --inputbox "Enter the path for Vaultwarden data (e.g., /vw-data/):" 8 50 "./Data/vw-data" 3>&1 1>&2 2>&3 3>&-)
ADMIN_TOKEN=$(dialog --title "Admin token" --inputbox "Enter the admin token for Vaultwarden:" 8 50 "$(openssl rand -base64 32)" 3>&1 1>&2 2>&3 3>&-)
SIGNUPS_ALLOWED=$(dialog --title "Signups Configuration" --yesno "Do you want to allow new user signups for Vaultwarden?" 7 60) && SIGNUPS_ALLOWED="true" || SIGNUPS_ALLOWED="false"
WEBSOCKET_ENABLED=$(dialog --title "WebSockets Configuration" --yesno "Do you want to enable WebSocket support for real-time updates?" 7 60) && WEBSOCKET_ENABLED="true" || WEBSOCKET_ENABLED="false"

COMPOSE_SUBFOLDER="./RRHQD-Dockers"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"
mkdir -p "$COMPOSE_SUBFOLDER"

{
  echo "version: '3'"
  echo "services:"
  echo "  $CONTAINER_NAME:"
  echo "    image: $IMAGE"
  echo "    ports:"
  echo "      - \"$PORT:80\""
  echo "    volumes:"
  echo "      - \"$DATA_PATH:/data\""
  echo "    environment:"
  echo "      - ADMIN_TOKEN=${ADMIN_TOKEN}"
  echo "      - WEBSOCKET_ENABLED=${WEBSOCKET_ENABLED}"
  echo "      - SIGNUPS_ALLOWED=${SIGNUPS_ALLOWED}"
} > "$COMPOSE_FILE"

dialog --title "File Created" --msgbox "Docker compose file created at: $COMPOSE_FILE" 10 60

# Use dialog to inform the user about Docker status and actions
OS_DISTRO=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')

check_docker() {
  if ! docker info >/dev/null 2>&1; then
    dialog --title "Docker not running" --msgbox "Docker does not seem to be running. Please start Docker first and then re-run this script." 7 60
    exit 1
  fi
}

start_docker_compose() {
  dialog --title "Starting Docker Compose" --infobox "Starting the Docker containers using docker-compose..." 4 60
  docker compose -f "$COMPOSE_FILE" up -d
}

case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    sudo -v && check_docker && sudo start_docker_compose || exit 1
    ;;
  *)
    check_docker && start_docker_compose
    ;;
esac

# Check if the Docker container(s) have started successfully
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    dialog --title "Success" --msgbox "The Docker container $CONTAINER_NAME has started successfully." 6 60
else
    dialog --title "Error" --msgbox "Failed to start the Docker container $CONTAINER_NAME. Please check the logs for details." 6 60
    exit 1
fi
