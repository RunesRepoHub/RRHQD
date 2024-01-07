# Decompress the backup archive on the remote machine
ssh "$REMOTE_USER@$REMOTE_IP" "tar -xzvf ~/$BACKUP_ARCHIVE -C ~/"

# Correct the path to the container export file after decompression
CONTAINER_EXPORT_PATH="~/backup_${SESSION_ID}/${CONTAINER_NAME}_container.tar"

# Load the Docker image on the remote machine using the corrected path
ssh "$REMOTE_USER@$REMOTE_IP" "docker load -i $CONTAINER_EXPORT_PATH"

# Start the Docker container using the loaded image
ssh "$REMOTE_USER@$REMOTE_IP" "docker run -d --name $CONTAINER_NAME_RESTORED $IMAGE_NAME"