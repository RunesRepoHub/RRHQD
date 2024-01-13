#!/bin/bash

clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy)" \
           --title "Quick Scripts Menu - $script_name" \
           --menu "Please select an option:" 15 60 4 \
           1 "Download YouTube Video" \
           2 "Download Fully Youtube Channel" \
           3 "Script 3 Description" \
           4 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_SCRIPTS_FOLDER/$YOUTUBE_DOWNLOAD
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_SCRIPTS_FOLDER/$YOUTUBE_CHANNEL_DOWNLOAD
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_SCRIPTS_FOLDER/Script3.sh
            ;;
        *)
            dialog --title "Exiting" --msgbox "Returning to the Main Menu." 6 52
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
