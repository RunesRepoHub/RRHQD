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

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="docker_export_run_"
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

# Function to export a Docker container
export_docker() {
  echo "Exporting Docker container $CONTAINER_NAME"
  docker commit "$CONTAINER_NAME" "${CONTAINER_NAME}_image"
  if [ $? -ne 0 ]; then
    echo "Failed to commit Docker container."
    exit 1
  fi
  docker save -o "$DOCKER_MIGRATION_PATH/${CONTAINER_NAME}_image.tar" "${CONTAINER_NAME}_image"
  if [ $? -ne 0 ]; then
    echo "Failed to save Docker image."
    exit 1
  fi
}

# Function to transfer Docker image and data to remote host
transfer_docker() {
  echo "Transferring Docker image and data to $REMOTE_HOST"
  scp "$DOCKER_MIGRATION_PATH/${CONTAINER_NAME}_image.tar" "$REMOTE_USER@$REMOTE_HOST:$DOCKER_MIGRATION_PATH"
  if [ $? -ne 0 ]; then
    echo "Failed to transfer Docker image."
    exit 1
  fi
}

# Function to verify the transfer
verify_transfer() {
  echo "Verifying transfer to $REMOTE_HOST"
  ssh "$REMOTE_USER@$REMOTE_HOST" "test -f $DOCKER_MIGRATION_PATH/${CONTAINER_NAME}_image.tar"
  if [ $? -ne 0 ]; then
    echo "Transfer failed."
    exit 1
  else
    echo "Transfer verified."
  fi
}

# Function to display commands using dialog message box
display_commands_dialog() {
  { echo "To load the Docker image on $REMOTE_HOST, run this command:"; echo "ssh $REMOTE_USER@$REMOTE_HOST \"$LOAD_COMMAND\""; echo ""; echo "To run the Docker container on $REMOTE_HOST, run this command:"; echo "ssh $REMOTE_USER@$REMOTE_HOST \"$RUN_COMMAND\""; } | dialog --title "Docker Commands" --msgbox "$(cat)" 20 70
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

echo "Docker export and migration completed."

