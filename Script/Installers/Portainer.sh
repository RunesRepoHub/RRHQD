#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/portainer_install.log"

increment_log_file_name() {
  local log_file_base_name="portainer_install_run_"
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
echo "Starting Portainer Docker configuration script."

IMAGE=$(dialog --inputbox "Enter the Docker image for Portainer (e.g., portainer/portainer-ce:latest):" 10 60 "portainer/portainer-ce:latest" 3>&1 1>&2 2>&3 3>&-)
CONTAINER_NAME=$(dialog --inputbox "Enter the name for the Portainer container:" 10 60 "portainer" 3>&1 1>&2 2>&3 3>&-)
PORT=$(dialog --inputbox "Enter the port to expose Portainer on (e.g., 9000):" 10 60 "9000" 3>&1 1>&2 2>&3 3>&-)
DATA_PATH=$(dialog --inputbox "Enter the volume path for Portainer data (e.g., /portainer-data/):" 10 60 "./Data/portainer-data" 3>&1 1>&2 2>&3 3>&-)
options=("Docker standalone" "Docker Swarm")
# Define the input file for dialog selections
INPUT=/tmp/menu.sh.$$

# Ensure the temp file is removed upon script termination
trap "rm -f $INPUT" 0 1 2 5 15

DEPLOYMENT_TYPE=$(dialog --menu "Choose the deployment type:" 12 60 2 \
  1 "Docker standalone" \
  2 "Docker Swarm" 3>&1 1>&2 2>&3)

COMPOSE_SUBFOLDER="./portainer-docker"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"
mkdir -p "$COMPOSE_SUBFOLDER"

# Define the Docker Compose configuration template
compose_template_standalone="version: '3'\nservices:\n  $CONTAINER_NAME:\n    image: $IMAGE\n    container_name: $CONTAINER_NAME\n    ports:\n      - \"$PORT:9000\"\n    volumes:\n      - $DATA_PATH:/data\n    restart: always"
compose_template_swarm="version: '3.8'\nservices:\n  $CONTAINER_NAME:\n    image: $IMAGE\n    ports:\n      - \"$PORT:9000\"\n    volumes:\n      - $DATA_PATH:/data\n    deploy:\n      mode: replicated\n      replicas: 1"

# Generate the Docker Compose file based on the selected deployment type
if [ "$DEPLOYMENT_TYPE" = "2" ]; then
  echo -e "$compose_template_swarm" > "$COMPOSE_FILE"
else
  echo -e "$compose_template_standalone" > "$COMPOSE_FILE"
fi

dialog --title "Docker Compose" --msgbox "Docker compose file for $DEPLOYMENT_TYPE created at: $COMPOSE_FILE" 6 50

OS_DISTRO=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    if ! sudo docker info >/dev/null 2>&1; then
      dialog --title "Error" --msgbox "Docker does not seem to be running, start it first with sudo and then re-run this script." 6 60
      exit 1
    fi
    sudo docker compose -f "$COMPOSE_FILE" up -d
    ;;
  *)
    if ! docker info >/dev/null 2>&1; then
      dialog --title "Error" --msgbox "Docker does not seem to be running, start it first and then re-run this script." 6 60
      exit 1
    fi
    docker compose -f "$COMPOSE_FILE" up -d
    ;;
esac
