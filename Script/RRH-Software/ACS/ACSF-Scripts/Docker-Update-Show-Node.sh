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

# Navigate to the Dockers directory
cd ~/RRHQD/Script/RRH-Software/ACS/Dockers


# Inform the user that the script is running
dialog --clear --title "Updating Docker containers" --msgbox "Updating all docker containers\\n\\nPlease wait..." 6 40


# Bring the containers down
sudo docker compose -f ~/RRHQD/Script/RRH-Software/ACS/Dockers/Deluge-compose.yml down

# Pull the latest images for the defined services
sudo docker compose -f ~/RRHQD/Script/RRH-Software/ACS/Dockers/Deluge-compose.yml pull

# Bring the containers back up
sudo docker compose -f ~/RRHQD/Script/RRH-Software/ACS/Dockers/Deluge-compose.yml up -d


# Bring the containers down
sudo docker compose -f ~/RRHQD/Script/RRH-Software/ACS/Dockers/Sonarr-compose.yml down

# Pull the latest images for the defined services
sudo docker compose -f ~/RRHQD/Script/RRH-Software/ACS/Dockers/Sonarr-compose.yml pull

# Bring the containers back up
sudo docker compose -f ~/RRHQD/Script/RRH-Software/ACS/Dockers/Sonarr-compose.yml up -d


# Bring the containers down
sudo docker compose -f ~/RRHQD/Script/RRH-Software/ACS/Dockers/Plex-compose.yml down

# Pull the latest images for the defined services
sudo docker compose -f ~/RRHQD/Script/RRH-Software/ACS/Dockers/Plex-compose.yml pull

# Bring the containers back up
sudo docker compose -f ~/RRHQD/Script/RRH-Software/ACS/Dockers/Plex-compose.yml up -d


dialog --clear --title "Docker containers updated" --msgbox "All Docker containers have been updated." 6 40
