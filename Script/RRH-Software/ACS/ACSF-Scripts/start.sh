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

containers_to_start=$(sudo docker ps -a -q --filter "status=exited" | wc -l)
if [ $containers_to_start -eq 0 ]; then
    dialog --clear --title "No containers to start" --msgbox "All docker containers are already running." 10 60
    exit 0
fi

# Start the dockers
dialog --clear --title "Starting dockers" --msgbox "plex, jackett, radarr, sonarr, tautulli, deluge and ombi\\n\\nStarting these containers may take a while.\\n\\nThe process may appear to hang, but it is not.\\n\\nPlease be patient." 10 60


sudo docker start plex jackett radarr sonarr tautulli deluge ombi


for container_name in plex jackett radarr sonarr tautulli deluge ombi; do
  if [[ $(docker inspect -f '{{.State.Running}}' $container_name) != "true" ]]; then
    dialog --clear --title "Starting $container_name" --msgbox "$container_name has not been started.\\n\\nPlease try again later." 10 60
    exit 1 
  fi
done 

dialog --clear --title "Started dockers" --msgbox "All plex, jackett, radarr, sonarr, tautulli, deluge and ombi have been started." 10 60