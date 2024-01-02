#!/bin/bash
# Script to list all stopped Docker containers and allow the user to select which to start using dialog

clear
source ~/RRHQD/Core/Core.sh

# Define the input file for dialog selections
INPUT=/tmp/containers.sh.$$

# Ensure the temp file is removed upon script termination
trap "rm -f $INPUT" 0 1 2 5 15

# Get the list of stopped containers
stopped_containers=$(docker ps -a --filter "status=exited" --format '{{.Names}}')

# Create an array for dialog options
options=()
for container in $stopped_containers; do
    options+=("$container" "")
done

# Use dialog to create a menu with stopped containers
dialog --clear \
       --backtitle "RRHQD Docker Control" \
       --title "Start Docker Containers" \
       --checklist "Select containers to start:" 15 60 6 \
       "${options[@]}" 2>"${INPUT}"

# Start selected containers
while IFS= read -r container; do
    echo "Starting $container..."
    docker start "$container"
done < "${INPUT}"

# Remove the temp file
rm -f "${INPUT}"
