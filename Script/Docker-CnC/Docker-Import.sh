#!/bin/bash

# Script to import and start a Docker container from an image transferred by the Docker-Export.sh script

# Variables for local configuration
read -p "Enter the remote host address: " REMOTE_HOST
read -p "Enter the remote user name: " REMOTE_USER
REMOTE_PATH="~/Docker"             # Replace with the actual remote directory path
LOCAL_PATH="~/Docker"              # Replace with the desired local directory path
LOG_FILE=~/docker_import.log       # Log file location

# Function to import Docker containers
import_docker() {
    local image_name=$1
    
    echo "Importing image $image_name from remote host $REMOTE_HOST" | tee -a "$LOG_FILE"
    scp "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/$image_name" "$LOCAL_PATH/" | tee -a "$LOG_FILE"
    
    local container_name="${image_name%_image.tar}"
    
    echo "Loading image into Docker" | tee -a "$LOG_FILE"
    docker load -i "$LOCAL_PATH/$image_name" | tee -a "$LOG_FILE"
    
    echo "Starting container from image" | tee -a "$LOG_FILE"
    docker run -d --name "$container_name" "${container_name}:latest" | tee -a "$LOG_FILE"
    
    echo "Cleaning up local image file $image_name" | tee -a "$LOG_FILE"
    rm "$LOCAL_PATH/$image_name" | tee -a "$LOG_FILE"
    
    echo "Import and start of $container_name completed" | tee -a "$LOG_FILE"
}

# Main script execution
{
    echo "Starting Docker import script at $(date)" | tee -a "$LOG_FILE"
    # Import and start Docker containers for each image file in the directory
    for image_file in $(ls "$LOCAL_PATH"/*.tar); do
        image_name=$(basename "$image_file")
        import_docker "$image_name"
    done
    echo "Docker import script completed at $(date)" | tee -a "$LOG_FILE"
} | tee -a "$LOG_FILE"  # Log everything within the block
