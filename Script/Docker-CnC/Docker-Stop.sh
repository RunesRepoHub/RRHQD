#!/bin/bash
# Stop all running Docker containers

echo "Stopping all running Docker containers..."
docker stop $(docker ps -q)

echo "All Docker containers have been stopped."
