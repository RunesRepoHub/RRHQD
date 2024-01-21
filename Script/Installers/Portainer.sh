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
DEPLOYMENT_TYPE=$(dialog --inputbox "Enter the deployment type (standalone or swarm):" 10 60 3>&1 1>&2 2>&3 3>&-)

COMPOSE_SUBFOLDER="./portainer-docker"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"
mkdir -p "$COMPOSE_SUBFOLDER"

if [ "$DEPLOYMENT_TYPE" = "swarm" ]; then
  cat > "$COMPOSE_FILE" <<EOF
version: '3.8'
services:
  $CONTAINER_NAME:
    image: $IMAGE
    ports:
      - "$PORT:9000"
    volumes:
      - $DATA_PATH:/data
    deploy:
      mode: replicated
      replicas: 1
EOF
else
  cat > "$COMPOSE_FILE" <<EOF
version: '3'
services:
  $CONTAINER_NAME:
    image: $IMAGE
    container_name: $CONTAINER_NAME
    ports:
      - "$PORT:9000"
    volumes:
      - $DATA_PATH:/data
    restart: always
EOF
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
    # Check if the Docker container(s) have started successfully
    if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        dialog --title "Success" --msgbox "The Docker container $CONTAINER_NAME has started successfully." 6 60
    else
        dialog --title "Error" --msgbox "Failed to start the Docker container $CONTAINER_NAME. Please check the logs for details." 6 60
        exit 1
    fi
    ;;
  *)
    if ! docker info >/dev/null 2>&1; then
      dialog --title "Error" --msgbox "Docker does not seem to be running, start it first and then re-run this script." 6 60
      exit 1
    fi
    docker compose -f "$COMPOSE_FILE" up -d
    # Check if the Docker container(s) have started successfully
    if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        dialog --title "Success" --msgbox "The Docker container $CONTAINER_NAME has started successfully." 6 60
    else
        dialog --title "Error" --msgbox "Failed to start the Docker container $CONTAINER_NAME. Please check the logs for details." 6 60
        exit 1
    fi
    ;;
esac