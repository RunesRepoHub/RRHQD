#!/bin/bash
# Script to export a Docker container with all its data for moving to a remote host

# Create the log directory if it doesn't exist
mkdir -p ~/RRHQD/log

# Log file location
LOG_FILE=~/RRHQD/log/docker-export-$(date '+%Y-%m-%d_%H-%M-%S').log

# Redirect stdout and stderr to log file
exec &> >(tee -a "$LOG_FILE")

echo "Export script started at $(date)"

# Get a list of all running Docker containers
DOCKER_CONTAINERS=$(docker ps --format '{{.Names}}')

# Check if there are any containers to export
if [ -z "$DOCKER_CONTAINERS" ]; then
  echo "No running Docker containers to export."
  exit 1
fi

# Display a list of containers and prompt user to select one to export
echo "Select the Docker container to export:"
select CONTAINER_NAME in $DOCKER_CONTAINERS; do
  if [ -n "$CONTAINER_NAME" ]; then
    break
  else
    echo "Invalid selection. Please try again."
  fi
done

# Export the selected Docker container to a file
CONTAINER_EXPORT_FILE=~/RRHQD/export/${CONTAINER_NAME}-$(date '+%Y-%m-%d_%H-%M-%S').tar

# Export container
docker export "$CONTAINER_NAME" -o "$CONTAINER_EXPORT_FILE"
echo "Docker container $CONTAINER_NAME exported to $CONTAINER_EXPORT_FILE"

# Export container's volumes
VOLUME_EXPORT_PATH=~/RRHQD/export/${CONTAINER_NAME}_volumes
mkdir -p "$VOLUME_EXPORT_PATH"
CONTAINER_VOLUMES=$(docker inspect "$CONTAINER_NAME" | jq -r '.[0].Mounts[] | select(.Type == "volume") .Name')

for VOLUME in $CONTAINER_VOLUMES; do
    VOLUME_FILE="${VOLUME_EXPORT_PATH}/${VOLUME}.tar.gz"
    docker run --rm -v "$VOLUME":/volume -v "$VOLUME_EXPORT_PATH":/backup alpine tar czf /backup/"${VOLUME_FILE##*/}" -C /volume .
    echo "Volume $VOLUME exported to $VOLUME_FILE"
done


# Function to push container and volumes to remote host
push_to_remote_host() {
  # Remote host information
  REMOTE_HOST="user@remote-server"
  REMOTE_PATH="/remote/path/for/docker_exports"

  # Push the container export file to the remote host
  scp "$CONTAINER_EXPORT_FILE" "${REMOTE_HOST}:${REMOTE_PATH}"

  # Push the volume exports to the remote host
  scp "${VOLUME_EXPORT_PATH}"/*.tar.gz "${REMOTE_HOST}:${REMOTE_PATH}/${CONTAINER_NAME}_volumes/"

  echo "Docker container and volumes have been pushed to the remote host."
}

# Call the function to push to remote host after export
push_to_remote_host

