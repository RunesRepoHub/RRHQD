#!/bin/bash
# Script to stop all running Docker containers and delete all Docker objects

echo "Stopping all running Docker containers..."
docker stop $(docker ps -aq)

echo "Removing all Docker containers..."
docker rm $(docker ps -aq)

echo "Removing all Docker images..."
docker rmi $(docker images -q) --force

echo "Removing all Docker volumes..."
docker volume rm $(docker volume ls -q)

echo "Removing all Docker networks..."
docker network rm $(docker network ls -q)

echo "Docker system pruning to remove any remaining unused data..."
docker system prune -a --volumes --force

echo "Docker reset completed."
