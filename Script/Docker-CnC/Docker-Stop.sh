#!/bin/bash
# Script to stop all running Docker containers and allow user to pick which ones to remove

echo "Fetching all Docker containers..."
docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"

# Ask the user if they want to remove a container
while true; do
    read -p "Do you want to remove a Docker container? [y/N]: " answer
    case $answer in
        [Yy]* )
            read -p "Enter the ID or name of the Docker container to remove: " container_id
            docker stop $container_id
            ;;
        [Nn]* )
            echo "No containers removed."
            break
            ;;
        * )
            echo "Please answer yes or no."
            ;;
    esac
done

echo "Script completed."
