#!/bin/bash

# RRHQD/Script/Docker-CnC/Docker-Update.sh

# Function to list all running Docker containers
list_containers() {
  docker ps --format "{{.Names}}" | nl -w2 -s ') '
}

# Function to get the image of a specific Docker container
get_container_image() {
  docker inspect --format='{{.Config.Image}}' "$1"
}

# Function to update the Docker container
update_container() {
  local container_name="$1"
  local container_image="$(get_container_image "$container_name")"

  echo "Updating $container_name with image $container_image..."
  docker pull "$container_image" && \
  docker stop "$container_name" && \
  docker rm "$container_name" && \
  docker run -d --name "$container_name" "$container_image"
}

# Define the input file for dialog selections
INPUT="/tmp/containers.sh.$$"

# Ensure the temp file is removed upon script termination
trap 'rm -f "$INPUT"' EXIT INT TERM HUP

# Get the list of running containers and create an array for dialog options
mapfile -t running_containers < <(docker ps --format '{{.Names}}')
options=()
for container in "${running_containers[@]}"; do
    options+=("$container" "" OFF)
done

# Use dialog to create a menu with running containers
dialog --clear \
       --backtitle "RRHQD Docker Control" \
       --title "Update Docker Containers" \
       --checklist "Select containers to update:" 15 60 6 \
       "${options[@]}" 2>"$INPUT"

# Check if the dialog was cancelled
if [ $? -eq 0 ]; then
    # Update selected containers
    while IFS= read -r container; do
        update_container "$container"
    done < "$INPUT"
else
    echo "Container update cancelled."
fi

# Remove the temp file
rm -f "$INPUT"

echo "Update process completed."

