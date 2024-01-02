#!/bin/bash
# Script to start Docker containers selected by the user via a checkbox interface

echo "Fetching all stopped Docker containers..."
containers=$(docker ps -a --filter status=exited --format "{{.ID}} {{.Names}}")

# Define a function to use dialog to present a checklist for starting containers
select_containers_to_start() {
    local cmd=(dialog --separate-output --checklist "Select containers to start:" 22 76 16)
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
        echo "Cannot proceed without 'dialog'. Exiting."
        exit 1
    fi
fi

# Call the function and store the selected containers
selected_containers=$(select_containers_to_start)

# Start the selected containers
IFS=$'\n'
for id in $selected_containers; do
    docker start $id
done
