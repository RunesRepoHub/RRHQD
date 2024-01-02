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

# Main menu
echo "Select Docker containers to update:"
list_containers
read -p "Enter the numbers of the containers to update (separated by spaces): " input

# Split the input into an array
IFS=' ' read -r -a selections <<< "$input"

# Loop over the selections and update the corresponding containers
for selection in "${selections[@]}"; do
  # Fetch the container name by its number
  container_name=$(list_containers | sed "${selection}q;d" | awk '{print $2}')

  # Update the container
  if [ -n "$container_name" ]; then
    update_container "$container_name"
  else
    echo "Invalid selection: $selection"
  fi
done

echo "Update process completed."
