#!/bin/bash

LOG_DIR="$HOME/ACS/logs"
# Configuration
LOG_FILE="$LOG_DIR/uninstall.log"  # Log file location for uninstall script

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="uninstall_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file for uninstall will be saved as $LOG_FILE"
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

source ~/ACS/ACSF-Scripts/Core.sh

echo -e "${Purple}Do you want to save all the files in the plex media folder or delete them?${NC}"
echo -e "${Green}y = Keep plex media folder${NC}"
echo -e "${Red}n = Delete plex media folder${NC}"

# Prompt the user for a yes/no answer
read -p "Are you sure? (y/n): " answer

# Check the user's response
if [[ $answer == "y" ]]; then
    # User answered "yes"
    
    # Stop and remove any docker with the image mikenye/youtube-dl
    echo -e "${Red}Stopping any and all mikenye/youtube-dl dockers then delete them${NC}"
    container_count=$(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}" | wc -l)
    for container_id in $(sudo docker ps -a --filter="ancestor=mikenye/youtube-dl" --format "{{.ID}}"); do
        sudo docker stop $container_id
    done
    echo -e "${Green}All mikenye/youtube-dl dockers have been stopped and removed${NC}"
    
    # Stop and remove the dockers
    echo -e "${Red}Stopping jackett, radarr, sonarr, tautulli, deluge and ombi${NC}"
    sudo docker stop jackett radarr sonarr tautulli deluge ombi 
    sudo docker rm jackett radarr sonarr tautulli deluge ombi
    echo -e "${Green}All jackett, radarr, sonarr, tautulli, deluge and ombi dockers have been stopped${NC}"

        # Remove the network
    echo -e "${Red}Removing the network my_plex_network${NC}"
    sudo docker network rm my_plex_network
    echo -e "${Green}The network my_plex_network has been removed${NC}"

    # remove all folders and files
    rm -rf ~/ACS 
    echo -e "${Green}All folders and files has been removed except the plex media folder, all dockers has been stopped${NC}"

    # Remove the line from the crontab file
    sudo sed -i '/ACS\/ACSF-Scripts\/automated-check.sh/d' /etc/crontab
    
elif [[ $answer == "n" ]]; then
    # User answered "no"
    
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

    # remove all folders and files
    echo -e "${Purple}Cleanup all folders and files...${NC}"
    rm -rf ~/ACS  ~/plex
    echo -e "${Green}All folders and files has been removed except the plex media folder, all dockers has been stopped${NC}"

    # Remove the line from the crontab file
    sudo sed -i '/ACS\/ACSF-Scripts\/automated-check.sh/d' /etc/crontab
else
    # User entered an invalid response
    echo -e "${Red}Error code: 400${NC}"
    echo -e "${Red}Invalid input!${NC}"
fi

