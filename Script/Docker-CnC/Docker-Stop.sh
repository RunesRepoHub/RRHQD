#!/bin/bash
# Script to list all running Docker containers and allow the user to select which to stop using dialog

clear
source ~/RRHQD/Core/Core.sh

# Define the input file for dialog selections
INPUT=/tmp/containers.sh.$$

# Ensure the temp file is removed upon script termination
trap "rm -f $INPUT" 0 1 2 5 15

# Get the list of running containers
running_containers=$(docker ps --format '{{.Names}}')

# Create an array for dialog options
options=()
for container in $running_containers; do
    options+=("$container" "")
done

# Use dialog to create a menu with running containers
dialog --clear \
       --backtitle "RRHQD Docker Control" \
       --title "Stop Docker Containers" \
       --checklist "Select containers to stop:" 15 60 6 \
       "${options[@]}" 2>"${INPUT}"

# Stop selected containers
while IFS= read -r container; do
    echo "Stopping $container..."
    docker stop "$container"
done < "${INPUT}"

# Remove the temp file
rm -f "${INPUT}"
