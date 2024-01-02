#!/bin/bash
# Start all Docker containers

# List all container IDs and start them using docker start
docker start $(docker ps -aq)

echo "All Docker containers have been started."