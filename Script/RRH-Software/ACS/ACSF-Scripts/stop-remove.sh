#!/bin/bash

LOG_DIR="$HOME/ACS/logs"
# Configuration
LOG_FILE="$LOG_DIR/docker_cleanup.log"  # Log file location for docker cleanup

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="docker_cleanup_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file for docker cleanup will be saved as $LOG_FILE"
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

source ~/ACS/ACSF-Scripts/Core.sh

# Stop and remove any docker with the image mikenye/youtube-dl
echo -e "${Red}Stopping any and all mikenye/youtube-dl dockers then delete them${NC}"
container_count=$(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}" | wc -l)
for container_id in $(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}"); do
    sudo docker stop $container_id
done
echo -e "${Green}All mikenye/youtube-dl dockers have been stopped and removed${NC}"


# Stop and remove the dockers
echo -e "${Red}Stopping and removing plex, jackett, radarr, sonarr, tautulli, deluge and ombi${NC}"
sudo docker stop plex jackett radarr sonarr tautulli deluge ombi
sudo docker rm plex jackett radarr sonarr tautulli deluge ombi
echo -e "${Green}All plex, jackett, radarr, sonarr, tautulli, deluge and ombi have been stopped and removed${NC}"


# Remove the network
echo -e "${Red}Removing the network my_plex_network${NC}"
sudo docker network rm my_plex_network
echo -e "${Green}The network my_plex_network has been removed${NC}"
