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

# start any docker with the image mikenye/youtube-dl
dialog --clear --title "Starting mikenye/youtube-dl containers" --msgbox "Starting any and all mikenye/youtube-dl dockers may take a while.\\n\\nThe process may appear to hang, but it is not.\\n\\nPlease be patient." 10 60
container_count=$(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}" | wc -l)
for container_id in $(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}"); do
   sudo docker start $container_id
done

dialog --clear --title "Started mikenye/youtube-dl containers" --msgbox "All mikenye/youtube-dl dockers have been started." 10 60

# Start the dockers
dialog --clear --title "Starting plex, jackett, radarr, sonarr, tautulli, deluge and ombi" --msgbox "Starting these containers may take a while.\\n\\nThe process may appear to hang, but it is not.\\n\\nPlease be patient." 10 60
docker start plex jackett radarr sonarr tautulli deluge ombi
dialog --clear --title "Started plex, jackett, radarr, sonarr, tautulli, deluge and ombi" --msgbox "All plex, jackett, radarr, sonarr, tautulli, deluge and ombi have been started." 10 60
