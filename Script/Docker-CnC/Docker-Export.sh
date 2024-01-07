#!/bin/bash

# Script to export Docker containers to a remote host and log the activity

# Variables for remote host configuration
read -p "Enter the remote host address: " REMOTE_HOST
read -p "Enter the remote user name: " REMOTE_USER
REMOTE_PATH="~/Docker"  # Replace with the remote directory path

# Log file location
LOG_FILE=~/docker_export.log

# Function to export Docker containers
export_docker() {
    local container_id=$1
    local image_name="${container_id}_image.tar"
    
    echo "Exporting container $container_id to image $image_name" | tee -a "$LOG_FILE"
    docker save -o "$image_name" "$container_id" | tee -a "$LOG_FILE"
    
    echo "Transferring image to remote host $REMOTE_HOST" | tee -a "$LOG_FILE"
    scp "$image_name" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH" | tee -a "$LOG_FILE"
    
    echo "Cleaning up local image $image_name" | tee -a "$LOG_FILE"
    rm "$image_name" | tee -a "$LOG_FILE"
    
    echo "Export and transfer of $container_id completed" | tee -a "$LOG_FILE"
}

# Main script execution
{
    echo "Starting Docker export script at $(date)" 
    # Export all running Docker containers
    for container in $(docker ps -q); do
        export_docker "$container"
    done
    echo "Docker export script completed at $(date)"
} | tee -a "$LOG_FILE"  # Log everything within the block
