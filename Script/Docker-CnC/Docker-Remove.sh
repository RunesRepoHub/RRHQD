#!/bin/bash

# Define the input file for dialog selections
INPUT=/tmp/menu.sh.$$
OUTPUT=/tmp/output.sh.$$

# Function to list and select Docker containers for deletion
function show_docker_delete_menu() {
    local containers=($(docker ps -a --format "{{.Names}}"))
    local options=()

    for container in "${containers[@]}"; do
        options+=("$container" "" OFF)
    done

    dialog --clear \
           --backtitle "Docker Management" \
           --title "Select Docker Containers to Delete" \
           --checklist "Use SPACE to select containers to delete:" 15 60 6 \
           "${options[@]}" 2>"${OUTPUT}"

    if [ $? -eq 0 ]; then
        # When user presses 'OK', containers to delete are stored in $OUTPUT
        local selected_containers=($(<"${OUTPUT}"))
        for container in "${selected_containers[@]}"; do
            docker rm -f "$container"
        done
    fi
}

# Ensure the temp files are removed upon script termination
trap "rm -f $INPUT $OUTPUT" 0 1 2 5 15

# Show the menu
show_docker_delete_menu
