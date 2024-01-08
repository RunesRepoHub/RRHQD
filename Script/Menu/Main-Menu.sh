#!/bin/bash
clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy)" \
           --title "Main Menu - $script_name" \
           --menu "Please select an option:" 15 60 7 \
           1 "Find and install a Docker" \
           2 "Find and install RunesRepoHub Software" \
           3 "Find and use a Quick Installer for other software" \
           4 "Add Cronjobs Quickly" \
           5 "Docker-CnC Scripts" \
           6 "Update" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$DOCKER
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$RRH_SOFTWARE
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$QUICK_INSTALLERS
            ;;
        4)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$CRONJOB
            ;;
        5)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$DOCKER_CNC
            ;;
        6)
            dialog --msgbox "Updating..." 3 50
            cd $ROOT_FOLDER
            git pull
            dialog --msgbox "You can now run the script fully updated" 5 50
            exit 0
            ;;
        *)
            dialog --title "Exiting" --msgbox "Thank you for using RRHQD. Support me via github https://github.com/RunesRepoHub/" 6 52
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
