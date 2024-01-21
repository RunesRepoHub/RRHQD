#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/ntfy_install.log"  # Log file location

increment_log_file_name() {
  local log_file_base_name="ntfy_install_run_"
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
echo "Starting NTFY Docker configuration script."

# Check for dialog command
if ! command -v dialog &> /dev/null; then
    echo "The 'dialog' command is not found but is required for this script."
    echo "Please install 'dialog' using your package manager, then re-run this script."
    exit 1
fi

# Use dialog to get user input for Docker image
IMAGE=$(dialog --title "Docker Image" --inputbox "Enter the Docker image for NTFY (e.g., binwiederhier/ntfy:latest):" 10 60 "binwiederhier/ntfy:latest" 3>&1 1>&2 2>&3 3>&- || echo "binwiederhier/ntfy:latest")

# Use dialog to get user input for container name
CONTAINER_NAME=$(dialog --title "NTFY Container Name" --inputbox "Enter the name for the NTFY container:" 10 60 "ntfy-container" 3>&1 1>&2 2>&3 3>&- || echo "ntfy-container")

# Use dialog to get user input for port
PORT=$(dialog --title "NTFY Port" --inputbox "Enter the port to expose NTFY on (e.g., 8080):" 10 60 "8080" 3>&1 1>&2 2>&3 3>&- || echo "8080")

# Use dialog to get user input for data path
DATA_PATH=$(dialog --title "NTFY Data Path" --inputbox "Enter the path for NTFY data (e.g., /ntfy-data/):" 10 60 "./Data/ntfy-data" 3>&1 1>&2 2>&3 3>&- || echo "./Data/ntfy-data")

COMPOSE_SUBFOLDER="./ntfy-docker"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

mkdir -p "$COMPOSE_SUBFOLDER"

{
echo "version: '3'"
echo "services:"
echo "  $CONTAINER_NAME:"
echo "    image: $IMAGE"
echo "    container_name: $CONTAINER_NAME"
echo "    command:"
echo "      - serve"
echo "    environment:"
echo "      - TZ=UTC"
echo "    volumes:"
echo "      - $DATA_PATH:/var/cache/ntfy"
echo "      - /etc/ntfy:/etc/ntfy"
echo "    ports:"
echo "      - \"$PORT:80\""
echo "    restart: always"
} > "$COMPOSE_FILE"

echo "Docker compose file created at: $COMPOSE_FILE"

OS_DISTRO=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')

case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    DOCKER_COMPOSE_CMD="sudo docker compose"
    ;;
  *)
    DOCKER_COMPOSE_CMD="docker compose"
    ;;
esac

if ! $DOCKER_COMPOSE_CMD info >/dev/null 2>&1; then
  echo "Docker does not seem to be running, start it first with 'sudo' if required and then re-run this script."
  exit 1
fi

$DOCKER_COMPOSE_CMD -f "$COMPOSE_FILE" up -d
