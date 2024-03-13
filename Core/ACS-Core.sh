##########################################################################
#####  Set variables for YT-Plex  # Core.sh # Made for @runesrepohub #####
########################## Made for @rune004 #############################
##########################################################################
##### Styles ######
Black='\e[0;30m'
DarkGray='\e[1;30m'
Red='\e[0;31m'
LightRed='\e[1;31m'
Green='\e[0;32m'
LightGreen='\e[1;32m'
BrownOrange='\e[0;33m'
Yellow='\e[1;33m'
Blue='\e[0;34m'
LightBlue='\e[1;34m'
Purple='\e[0;35m'
LightPurple='\e[1;35m'
Cyan='\e[0;36m'
LightCyan='\e[1;36m'
LightGray='\e[0;37m'
White='\e[1;37m'
NC='\e[0m'  # Reset to default
############################################################################
### Admin Stuff # Setup.sh ###
#----------------------------#
# Script folder path 
#ROOT_FOLDER=~/RRHQD/Script/RRH-Software/ACS/ACSF-Scripts
#----------------------------#
##########################################################################
#########  Set variables  # For setup.sh # Made for @runesrepohub ########
##########################################################################
# Installer checks
# User checks before installation
# Reponses for user input
# Install
#--------------------------------------------------------------------------
# All script names + file format
DOCKER_STOP="docker-stop.sh"
STOP="stop.sh"
STOP_REMOVE="stop-remove.sh"
UNINSTALL="uninstall.sh"
SETUP_PLEX="setup-plex.sh"
START="start.sh"
USAGE="youtube-size.sh"
#--------------------------------------------------------------------------
# Make folders for ACS
YOUTUBE=~/plex/media/youtube
YOUTUBE_AUDIO=~/plex/media/youtube_audio 
TRANSCODE=~/plex/transcode 
LIBRARY=~/plex/library 
JACKETT=~/ACS-Dockers/jackett 
RADARR=~/ACS-Dockers/radarr 
MOVIES=~/plex/media/movies 
SONARR=~/ACS-Dockers/sonarr 
SHOWS=~/plex/media/Shows 
MEDIA_DOWNLOAD=~/plex/media/download 
TAUTALLI=~/ACS-Dockers/tautalli 
DELUGE=~/ACS-Dockers/deluge 
OMBI=~/ACS-Dockers/ombi  
DOWNLOAD_COMPLETED=~/plex/media/download/completed
#--------------------------------------------------------------------------
# Container max
CONTAINER_MAX_FILE=~/ACS-Dockers/.max_containers
#--------------------------------------------------------------------------
# Cronjob
CRON_TIMER="*/20 * * * *"
#--------------------------------------------------------------------------
##########################################################################
###### Set variables  # For setup-plex.sh # Made for @runesrepohub #######
##########################################################################
DOCKER_ROOT_FOLDER=~/ACS-Dockers
DOCKER_CONFIG_FOLDER="config"
DOCKER_PLEX_LIBRARY_FOLDER=$LIBRARY
DOCKER_TRANSCODE_FOLDER=~/plex/transcode/temp
DOCKER_TRANSCODE_MOUNT="transcode"
DOCKER_PLEX_MEDIA=$MEDIA
DOCKER_PLEX_DATA="data"
DOCKER_PLEX_FOLDER="plex"
DOCKER_OMBI_FOLDER="ombi"
DOCKER_JACKETT_FOLDER="jackett"
DOCKER_RADARR_FOLDER="radarr"
DOCKER_SONARR_FOLDER="sonarr"
DOCKER_TAUTULLI_FOLDER="tautulli"
DOCKER_DELUGE_FOLDER="deluge"
DOCKER_DOWNLOAD_FOLDER=$MEDIA_DOWNLOAD
DOCKER_MOUNT_DOWNLOAD_FOLDER="downloads"
DOCKER_HOST_SHOWS_FOLDER=$SHOWS
DOCKER_SHOWS_FOLDER="shows"
DOCKER_HOST_MOVIES_FOLDER=$MOVIES
DOCKER_MOVIES_FOLDER="movies"
DOCKER_RESTART_ALWAYS="always"
##########################################################################
