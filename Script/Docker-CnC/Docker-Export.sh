#!/bin/bash
# RRHQD/Script/Docker-CnC/Docker-Export.sh
# Script to export a Docker container and its data to another machine

# Prompt for the name of the container to export
read -p "Enter the name of the Docker container to export: " CONTAINER_NAME

# Check if the Docker container exists
if ! docker inspect "$CONTAINER_NAME" &>/dev/null; then
    echo "Error: Container $CONTAINER_NAME does not exist."
    exit 1
fi

# Stop the container before exporting
docker stop "$CONTAINER_NAME"

# Export the container to a tar file
CONTAINER_EXPORT_PATH="./${CONTAINER_NAME}_container.tar"
docker export "$CONTAINER_NAME" > "$CONTAINER_EXPORT_PATH"
echo "Docker container exported to $CONTAINER_EXPORT_PATH"

# Find the data volume(s) used by the container and create a backup
VOLUMES=$(docker inspect --format='{{range .Mounts}}{{println .Name}}{{end}}' "$CONTAINER_NAME")
for VOLUME in $VOLUMES; do
    VOLUME_BACKUP_PATH="./${VOLUME}_backup.tar"
    docker run --rm -v "$VOLUME":/"$VOLUME" -v "$(pwd)":/backup ubuntu tar cvf /backup/"$VOLUME_BACKUP_PATH" -C / "$VOLUME"
    echo "Volume $VOLUME exported to $VOLUME_BACKUP_PATH"
done

# Instructions for moving to other machine

# Generate a unique identifier for the session to avoid file name collision
SESSION_ID=$(date +%s)

# Create a directory to store the backup files
BACKUP_DIR="./backup_${SESSION_ID}"
mkdir -p "$BACKUP_DIR"

# Move the container export and volume backups to the backup directory
mv "${CONTAINER_NAME}_container.tar" "$BACKUP_DIR"
for VOLUME in $VOLUMES; do
    mv "${VOLUME}_backup.tar" "$BACKUP_DIR"
done

# Compress the backup directory into a single archive for easy transfer
BACKUP_ARCHIVE="backup_${SESSION_ID}.tar.gz"
tar -czvf "$BACKUP_ARCHIVE" -C "$BACKUP_DIR" .

read -p "Enter the username: " username
read -p "Enter the IP address: " ip_address

# Check if scp is installed on the other machine and install it if not
ssh $username@$ip_address 'command -v scp >/dev/null 2>&1 || { echo "scp is not installed. Installing..."; sudo apt-get update && sudo apt-get install -y openssh-client; }'

echo "Enter the destination path for the backup on the other machine, for example: /path/to/destination"
read -p "Enter the destination path for the backup on the other machine: " destination_path



# Provide the command to copy the backup archive to the other machine
echo "Use the following command to copy the backup to the other machine:"
echo "scp $BACKUP_ARCHIVE $username@$ip_address:$destination_path"

# Start the Docker container from the backup on the other machine via ssh
ssh $username@$ip_address "docker load -i $destination_path/$BACKUP_ARCHIVE && docker run -d --name $CONTAINER_NAME_RESTORED <image>"
