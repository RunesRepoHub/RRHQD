#!/bin/bash
# Script to cleanup unused Docker resources including images, volumes, and networks

echo "Initiating Docker cleanup process..."

# Remove all unused images, not just dangling ones
docker image prune -a --force

# Remove all unused volumes
docker volume prune --force

# Remove all unused networks
docker network prune --force

echo "Docker cleanup completed."
