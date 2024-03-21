#!/bin/bash

SCRIPT_FILENAME=$(basename "$0")

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/"$SCRIPT_FILENAME"_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name=""$SCRIPT_FILENAME"_install_run_"
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


source ~/RRHQD/Core/ACS-Core.sh

# Set the IP address and time zone
IP=$(hostname -I | awk '{print $1}')
TZ=$(timedatectl show --property=Timezone --value)
PLEX_HOST=$(hostname)

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

fi

# Copy the Template ENV file to a new .env file
cp ~/RRHQD/Script/RRH-Software/ACS/Dockers/.env_Template ~/RRHQD/Script/RRH-Software/ACS/Dockers/.env

# Append environment variables to the ~/RRHQD/Script/RRH-Software/ACS/Dockers/.env file
{
    echo "IP=$IP"
    echo "TZ=$TZ"
    echo "PLEX_CLAIM=$PLEX_CLAIM"
    echo "PLEX_HOST=$PLEX_HOST"
} >> ~/RRHQD/Script/RRH-Software/ACS/Dockers/.env


# Start only the Plex docker container defined in the docker-compose file within the Dockers folder
PLEX_COMPOSE_FILE=~/RRHQD/Script/RRH-Software/ACS/Dockers/Plex-compose.yml
if [ -f "$PLEX_COMPOSE_FILE" ]; then
    sudo docker compose -f "$PLEX_COMPOSE_FILE" up -d
else
    echo -e "${Red}Plex docker-compose file not found${NC}"
fi

