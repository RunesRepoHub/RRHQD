#!/bin/bash
# Script to stop all running Docker containers and allow user to pick which ones to remove using a simple checkbox selection

echo "Fetching all Docker containers..."
containers=$(docker ps -a --format "{{.ID}} {{.Names}}")

# Define a function to use dialog to present a checklist
select_containers_to_remove() {
    local cmd=(dialog --separate-output --checklist "Select containers to remove:" 22 76 16)
    local options=()
    local container
    IFS=$'\n'
    for container in $containers; do
        options+=($container " " off)
    done
    "${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty
}

# Check if dialog is installed, if not, offer to install it
if ! command -v dialog &>/dev/null; then
    echo "The 'dialog' utility is not installed."
    read -p "Do you want to install 'dialog' to proceed with the container selection? [y/N]: " answer
    if [[ $answer =~ ^[Yy]$ ]]; then
        if command -v apt-get &>/dev/null; then
            sudo apt-get install dialog
        elif command -v yum &>/dev/null; then
            sudo yum install dialog
        else
            echo "Could not determine package manager. Please install 'dialog' manually."
            exit 1
        fi
    else
        echo "Cannot proceed with the container selection. Exiting."
        exit 1
    fi
fi

# Call the function and store the selected containers
selected_containers=$(select_containers_to_remove)

# Remove the selected containers
if [[ -n $selected_containers ]]; then
    while IFS= read -r container_id; do
        echo "Removing container: $container_id"
        docker stop "$container_id"
    done <<< "$selected_containers"
else
    echo "No containers selected for removal."
fi

# Clear up the dialog remnants
clear

echo "Script completed."

