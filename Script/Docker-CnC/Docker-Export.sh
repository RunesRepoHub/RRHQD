#!/bin/bash
# Script to export a Docker container, transfer it to another host, and run it there.

# Setup logging
LOGFILE="./docker-export.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "Logging initialized. All output will be saved to $LOGFILE"

# Prompt user for input
echo "Select the Docker container to export:"
select CONTAINER_NAME in $(docker ps --format '{{.Names}}'); do
  if [ -n "$CONTAINER_NAME" ]; then
    echo "You have selected the container: $CONTAINER_NAME"
    break
  else
    echo "Invalid selection. Please try again."
  fi
done


read -p "Enter the SSH username of the destination host: " SSH_USER
read -p "Enter the destination host address: " DEST_HOST

# Define the local user's home directory path for storing Docker exports
DEST_PATH="$HOME/docker_exports"

# Create the directory if it does not exist
mkdir -p "$DEST_PATH"

# Inform the user about the destination path
echo "Docker exports will be stored in: $DEST_PATH"

read -p "Enter the name for the Docker container on the new host: " NEW_CONTAINER_NAME

# Set the filename for the exported Docker container
EXPORT_FILE="${CONTAINER_NAME}.tar"

# Export the Docker container
echo "Exporting Docker container $CONTAINER_NAME..."
docker export "$CONTAINER_NAME" > "$EXPORT_FILE"

# Transfer the export to the new host
echo "Transferring export to $DEST_HOST..."
scp "$EXPORT_FILE" "${SSH_USER}@${DEST_HOST}:${DEST_PATH}/${EXPORT_FILE}"

# Run commands on the new host to load and run the Docker container
ssh "${SSH_USER}@${DEST_HOST}" bash -c "'
docker load -i ${DEST_PATH}/${EXPORT_FILE}
docker run --name ${NEW_CONTAINER_NAME} -d $(docker inspect --format='{{.Config.Cmd}}' ${CONTAINER_NAME}) $(docker inspect --format='{{range .Config.Env}}{{println \"-e\" .}}{{end}}' ${CONTAINER_NAME}) $(docker inspect --format='{{range .Config.ExposedPorts}}{{println \"-p\" .}}{{end}}' ${CONTAINER_NAME})
'"

# Clean up the exported file on the local machine
echo "Cleaning up local export file..."
rm "$EXPORT_FILE"

echo "Docker container $CONTAINER_NAME has been exported, transferred, and should now be running on $DEST_HOST as $NEW_CONTAINER_NAME."
