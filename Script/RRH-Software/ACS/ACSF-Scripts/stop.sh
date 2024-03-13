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

running_containers=$(sudo docker ps -q | wc -l)
if [ $running_containers -eq 0 ]; then
    dialog --clear --title "No docker containers running" --msgbox "No docker containers are currently running." 10 60
    exit 0
fi


# Stop and remove any docker with the image mikenye/youtube-dl
dialog --clear --title "Stopping mikenye/youtube-dl containers" --msgbox "Stopping all mikenye/youtube-dl containers..." 6 40
container_count=$(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}" | wc -l)
for container_id in $(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}"); do
    sudo docker stop $container_id
done 

dialog --clear --title "Stopping mikenye/youtube-dl containers" --msgbox "This may take a while..." 6 40

# Stop and remove the dockers
dialog --clear --title "Stop the dockers " --msgbox "plex, jackett, radarr, sonarr, tautulli, deluge and ombi\\n\\nStopping these containers may take a while.\\n\\nThe process may appear to hang, but it is not.\\n\\nPlease be patient." 10 60

sudo docker stop plex jackett radarr sonarr tautulli deluge ombi


for container_name in plex jackett radarr sonarr tautulli deluge ombi; do
  if [[ $(docker inspect -f '{{.State.Running}}' $container_name) == "true" ]]; then
    dialog --clear --title "Stopping $container_name" --msgbox "$container_name has not stopped.\\n\\nPlease try again later." 10 60
    exit 1
  fi
done 

dialog --clear --title "Stopped the dockers " --msgbox "All plex, jackett, radarr, sonarr, tautulli, deluge and ombi dockers have been stopped." 10 60
