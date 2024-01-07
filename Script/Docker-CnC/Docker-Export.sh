#!/bin/bash
# RRHQD/Script/Docker-CnC/Docker-Export.sh

DOCKER_MIGRATION_PATH=/opt/docker_migration
LOG_DIR="$HOME/RRHQD/logs"
REMOTE_USER=""
REMOTE_HOST=""
CONTAINER_NAME=""
IMAGE_NAME=""
PORTS=""
VOLUMES=""

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/docker_export.log"

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Function to export a Docker container
export_docker() {
  echo "Exporting Docker container $CONTAINER_NAME"
  docker commit "$CONTAINER_NAME" "${CONTAINER_NAME}_image"
  docker save -o "$DOCKER_MIGRATION_PATH/${CONTAINER_NAME}_image.tar" "${CONTAINER_NAME}_image"
}

# Function to transfer Docker image and data to remote host
transfer_docker() {
  echo "Transferring Docker image and data to $REMOTE_HOST"
  scp "$DOCKER_MIGRATION_PATH/${CONTAINER_NAME}_image.tar" "$REMOTE_USER@$REMOTE_HOST:$DOCKER_MIGRATION_PATH"
}

# Function to verify the transfer
verify_transfer() {
  echo "Verifying transfer to $REMOTE_HOST"
  ssh "$REMOTE_USER@$REMOTE_HOST" "test -f $DOCKER_MIGRATION_PATH/${CONTAINER_NAME}_image.tar && echo 'Transfer verified.' || echo 'Transfer failed.'"
}

# Function to load and run the Docker container on the remote host
load_and_run_docker() {
  echo "Loading and running Docker container on $REMOTE_HOST"
  ssh "$REMOTE_USER@$REMOTE_HOST" "docker load -i $DOCKER_MIGRATION_PATH/${CONTAINER_NAME}_image.tar \
                                    && docker run -d --name $CONTAINER_NAME $PORTS $VOLUMES ${CONTAINER_NAME}_image"
}

# Prompt user for remote host information
read -p "Enter the username for the remote host: " REMOTE_USER
read -p "Enter the IP address for the remote host: " REMOTE_HOST

# List running Docker containers for user to pick
docker ps --format "table {{.Names}}" | tee -a "$LOG_FILE"
read -p "Enter the name of the Docker container to export: " CONTAINER_NAME

# Retrieve container details
IMAGE_NAME=$(docker inspect --format='{{.Config.Image}}' "$CONTAINER_NAME")
PORTS=$(docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} -p {{$p}} {{$conf}} {{end}}' "$CONTAINER_NAME")
VOLUMES=$(docker inspect --format='{{range .Mounts}} -v {{.Source}}:{{.Destination}} {{end}}' "$CONTAINER_NAME")

# Start the export process
export_docker
transfer_docker
verify_transfer
load_and_run_docker

echo "Docker export and migration completed."
