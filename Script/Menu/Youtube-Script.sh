#!/bin/bash

clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy) - Youtube-Scripts" \
           --title "Quick Scripts Menu - $script_name" \
           --menu "Please select an option:" 15 60 4 \
           1 "Download YouTube Video" \
           2 "Download Fully Youtube Channel" \
           3 "Rescan Youtube Channel Downloads For New Videos" \
           4 "Download Playlist MP3" \
           5 "Stop all Youtube Downlaods" \
           6 "Add Youtube Script To Cronjob So It Will Rescan Every 4 Hours" \
           7 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$YOUTUBE_SCRIPTS_FOLDER/$YOUTUBE_DOWNLOAD
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$YOUTUBE_SCRIPTS_FOLDER/$YOUTUBE_CHANNEL_DOWNLOAD
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$YOUTUBE_SCRIPTS_FOLDER/$YOUTUBE_CHANNEL_AUTO
            ;;
        4)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$YOUTUBE_SCRIPTS_FOLDER/$YOUTUBE_AUDIO_PLAYLIST
            ;;
        5)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$YOUTUBE_SCRIPTS_FOLDER/$YOUTUBE_STOP_DOWNLOAD
            ;;
        6)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$YOUTUBE_SCRIPTS_FOLDER/$YOUTUBE_CRONJOB_DOWNLOAD
            ;;
        *)
            exit 0
            ;;
    esac
}

# Define the input file for dialog selections
INPUT=/tmp/menu.sh.$$

# Ensure the temp file is removed upon script termination
trap "rm -f $INPUT" 0 1 2 5 15

# Main loop
while true; do
    show_dialog_menu
done
