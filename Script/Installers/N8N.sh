#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/n8n_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="n8n_install_run_"
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
# Use dialog to interact with the user
if ! command -v dialog &> /dev/null; then
    echo "The dialog program could not be found, please install dialog to use this script."
    exit 1
fi

# Define the default settings
DEFAULT_IMAGE="n8nio/n8n:latest"
DEFAULT_CONTAINER_NAME="n8n-container"
DEFAULT_PORT=5678
DEFAULT_TZ="Europe/Berlin"
DEFAULT_DATA_PATH="./Data/n8n-data"
DEFAULT_GENERIC_TIMEZONE="UTC"

# Prompt user for input with defaults using dialog
IMAGE=$(dialog --title "Docker image configuration" --inputbox "Enter the Docker image for n8n:" 8 60 $DEFAULT_IMAGE 3>&1 1>&2 2>&3)
CONTAINER_NAME=$(dialog --title "Container name configuration" --inputbox "Enter the name for the n8n container:" 8 60 $DEFAULT_CONTAINER_NAME 3>&1 1>&2 2>&3)
PORT=$(dialog --title "Port configuration" --inputbox "Enter the port to expose n8n on:" 8 60 $DEFAULT_PORT 3>&1 1>&2 2>&3)
TZ=$(dialog --title "Timezone configuration" --inputbox "Enter the timezone:" 8 60 $DEFAULT_TZ 3>&1 1>&2 2>&3)
DATA_PATH=$(dialog --title "Data path configuration" --inputbox "Enter the path for n8n data:" 8 60 $DEFAULT_DATA_PATH 3>&1 1>&2 2>&3)
SUBDOMAIN=$(dialog --title "Subdomain configuration" --inputbox "Enter the subdomain for n8n:" 8 60 3>&1 1>&2 2>&3)
DOMAIN_NAME=$(dialog --title "Domain name configuration" --inputbox "Enter the domain name:" 8 60 3>&1 1>&2 2>&3)
GENERIC_TIMEZONE=$(dialog --title "Generic timezone configuration" --inputbox "Enter a generic timezone for n8n:" 8 60 $DEFAULT_GENERIC_TIMEZONE 3>&1 1>&2 2>&3)

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./n8n-docker"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Create a Docker compose file with the user input
cat > "$COMPOSE_FILE" <<EOF
version: '3'
services:
  $CONTAINER_NAME:
    image: $IMAGE
    environment:
      - TZ=$TZ
      - N8N_HOST=${SUBDOMAIN}.${DOMAIN_NAME}
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - NODE_ENV=production
      - WEBHOOK_URL=https://${SUBDOMAIN}.${DOMAIN_NAME}/
      - GENERIC_TIMEZONE=${GENERIC_TIMEZONE}
    volumes:
      - $DATA_PATH:/home/node/.n8n
    ports:
      - "$PORT:5678"
    restart: always

EOF

# Inform the user where the Docker compose file has been created
dialog --title "Success" --msgbox "Docker compose file created at: $COMPOSE_FILE" 6 50

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
  docker compose -f "$COMPOSE_FILE" up -d
}

case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    sudo start_container
    ;;
  *)
    start_container
    ;;
esac

# Check if the Docker container(s) have started successfully
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    dialog --title "Success" --msgbox "The Docker container $CONTAINER_NAME has started successfully." 6 60
else
    dialog --title "Error" --msgbox "Failed to start the Docker container $CONTAINER_NAME. Please check the logs for details." 6 60
    exit 1
fi