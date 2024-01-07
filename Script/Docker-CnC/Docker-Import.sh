#!/bin/bash
# Simple Bash script to spin up Docker containers from saved images



# Configuration
DOCKER_REMOTE_PATH=/var/lib/docker_migration/remote      # Remote directory path for Docker images
LOG_FILE="$LOG_DIR/docker_import.log"  # Log file location

# Create log directory if it doesn't exist
LOG_DIR="$HOME/RRHQD/log"
mkdir -p "$LOG_DIR"


# Redirect all output to log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Function to load Docker images and run containers from them
spin_up_docker() {
    local image_path=$1
    local image_name=$(basename "$image_path")
    local container_name="${image_name%_image.tar}"

    echo "Loading image $image_name" | tee -a "$LOG_FILE"
    docker load -i "$image_path" | tee -a "$LOG_FILE"

    echo "Starting container from $image_name" | tee -a "$LOG_FILE"
    docker run -d --name "$container_name" "${container_name}_image" | tee -a "$LOG_FILE"
}

# Main script execution
echo "Starting Docker spin up at $(date)" | tee -a "$LOG_FILE"

# List available Docker image files
echo "Available Docker image files:" | tee -a "$LOG_FILE"
ls "$DOCKER_REMOTE_PATH"/*.tar | tee -a "$LOG_FILE"

# Create an array to hold paths of Docker images
images=("$DOCKER_REMOTE_PATH"/*.tar)

# Display options for user to pick
echo "Please select an image to spin up by entering the corresponding number:"
select image_path in "${images[@]}"; do
    if [[ -n "$image_path" ]]; then
        echo "You have selected image: $image_path"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done
spin_up_docker "$image_path"

echo "Docker spin up completed at $(date)" | tee -a "$LOG_FILE"

