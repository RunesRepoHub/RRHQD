#!/bin/bash
# Script to start Docker containers selected by the user via a checkbox interface

echo "Fetching all stopped Docker containers..."
docker ps -a --filter status=exited --format "{{.ID}} {{.Names}}"

# Ask the user if they want to remove a container
while true; do
    read -p "Do you want to remove a Docker container? [y/N]: " answer
    case $answer in
        [Yy]* )
            read -p "Enter the ID or name of the Docker container to remove: " container_id
            docker start $container_id
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
