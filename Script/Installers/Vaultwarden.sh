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
SIGNUPS_ALLOWED=$(dialog --title "Signups allowed" --yesno "Allow signups?" 7 50 3>&1 1>&2 2>&3 3>&-)
SIGNUPS_ALLOWED=$([[ "$?" == 0 ]] && echo "true" || echo "false")
WEBSOCKET_ENABLED=$(dialog --title "WebSocket" --yesno "Enable WebSockets?" 7 50 3>&1 1>&2 2>&3 3>&-)
WEBSOCKET_ENABLED=$([[ "$?" == 0 ]] && echo "true" || echo "false")

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

echo "Docker compose file created at: $COMPOSE_FILE"

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

case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    sudo docker compose -f "$COMPOSE_FILE" up -d
    ;;
  *)
    docker compose -f "$COMPOSE_FILE" up -d
    ;;
esac
