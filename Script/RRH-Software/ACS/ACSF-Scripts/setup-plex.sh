#!/bin/bash

LOG_DIR="$HOME/ACS/logs"
# Configuration
LOG_FILE="$LOG_DIR/docker_cleanup.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="docker_cleanup_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file will be saved as $LOG_FILE"
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1


source ~/ACS/ACSF-Scripts/Core.sh

# Set the IP address and time zone
IP=$(hostname -I | awk '{print $1}')
TZ=$(timedatectl show --property=Timezone --value)

# Check if the network already exists
if sudo docker network inspect my_plex_network >/dev/null 2>&1; then
    echo -e "${Red}The network my_plex_network already exists${NC}"
    echo -e "${Red}The installation might fail due to this error${NC}"
else
    # Create the network
    sudo docker network create my_plex_network
fi

# Check if there is already a docker with the name plex running

if sudo docker ps -a --format '{{.Names}}' | grep -q "^plex$"; then
    echo -e "${Green}Plex is already running skipping plex claim${NC}"
else
    echo -e "${Green}Claim the Plex server${NC}"
    echo -e "${Green}https://www.plex.tv/claim/${NC}"

    # Prompt the user for the Plex claim
    read -p "Enter the Plex claim: " PLEX_CLAIM

    # Check if PLEX_CLAIM is empty
    if [ -z "$PLEX_CLAIM" ]; then
        echo -e "${Yellow}Error code: 1 (Invalid arguments)${NC}"
        exit 1
    fi


    echo -e "${Green}Enter the hostname that you want for the plex server in the plex settings${NC}"    
    # Prompt the user for the hostname
    read -p "Hostname for Plex-Server: " PLEX_HOST
fi


# Append environment variables to the ~/ACS/Dockers/.env file
{
    echo "IP=$IP"
    echo "TZ=$TZ"
    echo "PLEX_CLAIM=$PLEX_CLAIM"
    echo "PLEX_HOST=$PLEX_HOST"
} >> ~/ACS/Dockers/.env


# Start all docker containers defined in the docker-compose files within the Dockers folder
# and remove any orphan containers that are no longer defined in the docker-compose files
for compose_file in ~/ACS/Dockers/*.yml; do
    sudo docker compose -f "$compose_file" up -d
done

