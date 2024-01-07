#!/bin/bash
# Simple Bash script to migrate Docker containers from a local machine to a remote host

# Configuration
DOCKER_LOCAL_PATH=/var/lib/docker_migration/local        # Local directory path for Docker images
DOCKER_REMOTE_PATH=/var/lib/docker_migration/remote      # Remote directory path for Docker images
LOG_FILE="$LOG_DIR/docker_migration.log"  # Log file location

read -p "Enter the remote host IP or address: " REMOTE_HOST
read -p "Enter the remote user name: " REMOTE_USER

# Ensure local Docker migration path exists
mkdir -p "$DOCKER_LOCAL_PATH"

# Check the connection to the remote host and create the Docker migration path if the connection is successful
if ssh -q "$REMOTE_USER@$REMOTE_HOST" exit; then
  echo "Connection to $REMOTE_HOST successful."
  ssh "$REMOTE_USER@$REMOTE_HOST" "mkdir -p '$DOCKER_REMOTE_PATH'" && echo "Remote Docker migration path created."
else
  echo "Failed to connect to $REMOTE_HOST. Please check your settings."
  exit 1
fi

# Create log directory if it doesn't exist
LOG_DIR="$HOME/RRHQD/log"
mkdir -p "$LOG_DIR"

# Set log file location
LOG_FILE="$LOG_DIR/docker_migration.log"

# Redirect all output to log file
exec > >(tee -a "$LOG_FILE") 2>&1


# Function to save Docker containers as images and transfer them to a remote host
migrate_docker() {
    local container_id=$1
    local image_name="${container_id}_image.tar"

    echo "Saving container $container_id as image $image_name" | tee -a "$LOG_FILE"
    docker commit "$container_id" "${container_id}_image" | tee -a "$LOG_FILE"
    docker save -o "$LOCAL_PATH/$image_name" "${container_id}_image" | tee -a "$LOG_FILE"

    echo "Transferring image $image_name to remote host $REMOTE_HOST" | tee -a "$LOG_FILE"
    scp "$LOCAL_PATH/$image_name" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/" | tee -a "$LOG_FILE"

    echo "Cleaning up local image file $image_name" | tee -a "$LOG_FILE"
    rm "$LOCAL_PATH/$image_name" | tee -a "$LOG_FILE"
}

# Main script execution
echo "Starting Docker migration at $(date)" | tee -a "$LOG_FILE"

echo "Available Docker containers:"
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}" | tee -a "$LOG_FILE"

# Create an associative array to hold container ID and Names
declare -A containers
while IFS= read -r line; do
    container_id=$(echo "$line" | awk '{print $1}')
    container_name=$(echo "$line" | awk '{print $2}')
    containers[$container_id]=$container_name
done < <(docker ps --format "{{.ID}} {{.Names}}" | tail -n +2)

# Display options for user to pick
echo "Please select a container to migrate by entering the corresponding number:"
select container_id in "${!containers[@]}"; do
    if [[ -n "$container_id" ]]; then
        echo "You have selected container: ${containers[$container_id]} (ID: $container_id)"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done
migrate_docker "$container_id"

echo "Docker migration completed at $(date)" | tee -a "$LOG_FILE"
