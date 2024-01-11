#!/bin/bash



clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy) - Docker-CnC" \
           --title "Docker-CnC - $script_name" \
           --menu "Please select a Docker-CnC script to run:" 15 60 5 \
           1 "Docker - Cleanup" \
           2 "Docker - Start" \
           3 "Docker - Stop" \
           4 "Docker - Update" \
           5 "Docker - Reset" \
           6 "Docker - Remove" \
           7 "Docker - Export" \
           8 "Docker - Import" \
           9 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$DOCKER_CNC_FOLDER/$DOCKER_CLEANUP
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$DOCKER_CNC_FOLDER/$DOCKER_START
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$DOCKER_CNC_FOLDER/$DOCKER_STOP
            ;;
        4)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$DOCKER_CNC_FOLDER/$DOCKER_UPDATE
            ;;
        5)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$DOCKER_CNC_FOLDER/$DOCKER_RESET
            ;;
        6)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$DOCKER_CNC_FOLDER/$DOCKER_REMOVE
            ;;
        7)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$DOCKER_CNC_FOLDER/$DOCKER_EXPORT
            ;;
        8)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$DOCKER_CNC_FOLDER/$DOCKER_IMPORT
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

