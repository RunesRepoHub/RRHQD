#!/bin/bash
# Script to scan all Docker containers and ask the user which ones to delete using checkboxes.

# Define a temporary file to store the user's selections
SELECTIONS_FILE=$(mktemp)

# Function to display a checklist with Docker containers
choose_containers_to_delete() {
    # Get a list of all Docker containers (ID and Names)
    mapfile -t containers < <(docker ps -a --format '{{.ID}} {{.Names}}')

    # Create the checklist options
    local checklist_options=()
    for container in "${containers[@]}"; do
        checklist_options+=("$container" " " off)
    done

    # Display the checklist dialog
    dialog --checklist "Select Docker containers to delete:" 0 0 0 "${checklist_options[@]}" 2>"$SELECTIONS_FILE"
}

# Check if 'dialog' is installed
if ! command -v dialog &>/dev/null; then
    echo "The 'dialog' utility is not installed. Please install it to use this script."
    exit 1
fi

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "Docker does not seem to be running, start it first and then re-run this script."
    exit 1
fi

# Call the function to choose containers
choose_containers_to_delete

# Read the selections from the file
if [ -s "$SELECTIONS_FILE" ]; then
    # Read the selected container IDs into an array
    mapfile -t selected_containers < "$SELECTIONS_FILE"

    # Stop and remove the selected containers
    for container_id in "${selected_containers[@]}"; do
        echo "Deleting Docker container: $container_id"
        docker rm -f "$container_id"
    done
else
    echo "No containers were selected for deletion."
fi

# Clean up the temporary file
rm -f "$SELECTIONS_FILE"
