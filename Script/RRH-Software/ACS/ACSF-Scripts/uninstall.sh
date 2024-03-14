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


answer=$(dialog --clear --backtitle "ACS-Scripts" --title "Plex Media Folder" --yesno "Do you want to save all the files in the plex media folder or delete them?" 0 0 --yes-label "Save plex media folder" --no-label "Delete plex media folder" 3>&1 1>&2 2>&3)

# Check the user's response
if [[ $answer == "yes" ]]; then
    # User answered "yes"
    
    # Stop and remove any docker with the image mikenye/youtube-dl
    dialog --clear --title "Stopping and removeing mikenye/youtube-dl containers" --msgbox "Stopping and removeing all mikenye/youtube-dl containers..." 6 40
    container_count=$(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}" | wc -l)
    for container_id in $(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}"); do
        sudo docker stop $container_id
    done
    dialog --clear --title "Stopping and removed mikenye/youtube-dl containers" --msgbox "All mikenye/youtube-dl dockers have been stopped and removed." 6 40
    
    dialog --clear --title "Stop and remove the dockers " --msgbox "plex, jackett, radarr, sonarr, tautulli, deluge and ombi\\n\\nStopping and removing these containers may take a while.\\n\\nThe process may appear to hang, but it is not.\\n\\nPlease be patient." 10 60

    # Stop and remove the dockers
    sudo docker stop jackett radarr sonarr tautulli deluge ombi 
    sudo docker rm jackett radarr sonarr tautulli deluge ombi

    dialog --clear --title "Stopped and removed the dockers " --msgbox "All plex, jackett, radarr, sonarr, tautulli, deluge and ombi dockers have been stopped and removed." 10 60

    # Remove the network
    dialog --clear --title "Removing the network my_plex_network" --msgbox "Removing the network my_plex_network..." 6 40
    sudo docker network rm my_plex_network
    dialog --clear --title "Removed the network my_plex_network" --msgbox "The network my_plex_network has been removed." 6 40

    # remove all folders and files
    rm -rf ~/ACS-Dockers
    dialog --clear --title "Removed all folders and files" --msgbox "All folders and files has been removed except the plex media folder, all dockers has been stopped." 6 40

    # Remove the line from the crontab file
    sudo sed -i '/ACS\/ACSF-Scripts\/automated-check.sh/d' /etc/crontab
    
elif [[ $answer == "no" ]]; then
    # User answered "no"
    
    # Stop and remove any docker with the image mikenye/youtube-dl
    dialog --clear --title "Stopping and removeing mikenye/youtube-dl containers" --msgbox "Stopping and removeing all mikenye/youtube-dl containers..." 6 40
    container_count=$(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}" | wc -l)
    for container_id in $(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}"); do
        sudo docker stop $container_id
    done
    dialog --clear --title "Stopping and removed mikenye/youtube-dl containers" --msgbox "All mikenye/youtube-dl dockers have been stopped and removed." 6 40
    
    # Stop and remove the dockers
    dialog --clear --title "Stopping and removing dockers" --msgbox "Stopping and removing plex, jackett, radarr, sonarr, tautulli, deluge and ombi." 6 40
    sudo docker stop plex jackett radarr sonarr tautulli deluge ombi 
    sudo docker rm plex jackett radarr sonarr tautulli deluge ombi
    dialog --clear --title "Stopped and removed dockers" --msgbox "All plex, jackett, radarr, sonarr, tautulli, deluge and ombi dockers have been stopped and removed." 6 40
    
    # Remove the network
    dialog --clear --title "Removing the network my_plex_network" --msgbox "Removing the network my_plex_network..." 6 40
    sudo docker network rm my_plex_network
    dialog --clear --title "Removed the network my_plex_network" --msgbox "The network my_plex_network has been removed." 6 40
    
    # remove all folders and files
    dialog --clear --title "Removed all folders and files" --msgbox "Cleanup all folders and files..." 6 40
    rm -rf ~/ACS-Dockers  ~/plex
    dialog --clear --title "Removed all folders and files" --msgbox "All folders and files has been removed, all Dockers has been stopped and removed." 6 40

    # Remove the line from the crontab file
    sudo sed -i '/ACS\/ACSF-Scripts\/automated-check.sh/d' /etc/crontab
else
    # User entered an invalid response
    echo -e "${Red}Error code: 400${NC}"
    echo -e "${Red}Invalid input!${NC}"
fi

