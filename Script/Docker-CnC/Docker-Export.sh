#!/bin/bash
# RRHQD/Script/Docker-CnC/Docker-Export.sh
# Script to export a Docker container and its data to another machine

# Check if an SSH key already exists
if [[ ! -f ~/.ssh/id_rsa ]]; then
    # No SSH key found, create a new one
    echo "No SSH key found. Creating a new one..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
    echo "SSH key created."
else
    echo "SSH key already exists."
fi

# Set default SSH public key path
DEFAULT_SSH_KEY_PATH="$HOME/.ssh/id_rsa.pub"
SSH_KEY_PATH=${SSH_KEY_PATH:-"$DEFAULT_SSH_KEY_PATH"}

# Check if the SSH public key file exists
if [[ ! -f "$SSH_KEY_PATH" ]]; then
    echo "Error: SSH public key not found at $SSH_KEY_PATH."
    exit 1
fi

# Prompt for username and IP address of the other machine
read -p "Enter the username of the remote user: " REMOTE_USER
read -p "Enter the IP address of the remote machine: " REMOTE_IP

# Copy the SSH public key to the other machine's authorized_keys
echo "Copying SSH public key to $REMOTE_USER@$REMOTE_IP..."
ssh-copy-id -i "$SSH_KEY_PATH" "$REMOTE_USER@$REMOTE_IP"

if [[ $? -ne 0 ]]; then
    echo "Failed to copy SSH public key to the remote machine."
    exit 1
fi

echo "SSH public key successfully copied to the remote machine."

# List all running Docker containers and allow the user to select one for export
echo "Select the Docker container to export by entering the corresponding number:"
mapfile -t CONTAINER_NAMES < <(docker ps --format '{{.Names}}')
for i in "${!CONTAINER_NAMES[@]}"; do
    echo "$((i+1))) ${CONTAINER_NAMES[$i]}"
done

read -p "Enter the number of the Docker container to export: " CONTAINER_NUMBER
CONTAINER_NAME=${CONTAINER_NAMES[$((CONTAINER_NUMBER-1))]}

# Check if the user input is valid and the Docker container exists
if [[ "$CONTAINER_NUMBER" -gt 0 && "$CONTAINER_NUMBER" -le "${#CONTAINER_NAMES[@]}" ]] && docker inspect "$CONTAINER_NAME" &>/dev/null; then
    echo "You have selected the container: $CONTAINER_NAME"
else
    echo "Error: Invalid selection or container does not exist."
    exit 1
fi

# Retrieve the Docker image name used by the container
IMAGE_NAME=$(docker inspect --format='{{.Config.Image}}' "$CONTAINER_NAME")
echo "Docker image name retrieved: $IMAGE_NAME"

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

username="REMOTE_USER"
ip_address="REMOTE_IP"

# Check if scp is installed on the other machine and install it if not
ssh $username@$ip_address 'command -v scp >/dev/null 2>&1 || { echo "scp is not installed. Installing..."; sudo apt-get update && sudo apt-get install -y openssh-client; }'

# Provide the command to copy the backup archive to the other machine
# Place the backup file into the user's home directory on the remote machine
REMOTE_BACKUP_PATH="~/"
echo "Use the following command to copy the backup to the other machine:"
echo "scp $BACKUP_ARCHIVE $username@$ip_address:$REMOTE_BACKUP_PATH"

# Start the Docker container from the backup on the other machine via ssh
# Assuming the backup file is now in the user's home directory
ssh $username@$ip_address "docker load -i $REMOTE_BACKUP_PATH/$BACKUP_ARCHIVE && docker run -d --name $CONTAINER_NAME_RESTORED $IMAGE_NAME"
