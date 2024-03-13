#!/bin/bash

LOG_DIR="$HOME/ACS/logs"
# Configuration
LOG_FILE="$LOG_DIR/start_script.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="start_script_run_"
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

# start any docker with the image mikenye/youtube-dl
echo -e "${Purple}Starting any and all mikenye/youtube-dl dockers${NC}"
container_count=$(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}" | wc -l)
for container_id in $(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}"); do
   sudo docker start $container_id
done
echo -e "${Green}This may take a while...${NC}"
echo -e "${Green}All mikenye/youtube-dl dockers have been started${NC}"

# Start the dockers
echo -e "${Red}Starting plex, jackett, radarr, sonarr, tautulli, deluge and ombi${NC}"
docker start plex jackett radarr sonarr tautulli deluge ombi
echo -e "${Green}All plex, jackett, radarr, sonarr, tautulli, deluge and ombi have been started${NC}"
