#!/bin/bash

hostname=$(hostname)
ip=$(hostname -I | cut -d' ' -f1)

clear 
source ~/RRHQD/Core/Core.sh

cd $ROOT_FOLDER
dialog --backtitle "Update RRHQD (RunesRepoHub Quick Deploy) Running On $hostname ($ip)" --title "Update RRHQD Codebase" --infobox "Pulling updates from repository..." 5 60
sleep 1
git pull --progress > /tmp/git-pull-output.txt 2>&1
EXIT_STATUS=$?
if [ $EXIT_STATUS -eq 0 ]; then
    dialog --backtitle "Update RRHQD (RunesRepoHub Quick Deploy) Running On $hostname ($ip)" --title "Pulling Updates" --textbox /tmp/git-pull-output.txt 15 60
else
    dialog --title "Error" --textbox /tmp/git-pull-output.txt 15 60
fi


script_name=$(basename "$0" .sh)

function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy) - Main Menu Running On $hostname ($ip)" \
           --title "Main Menu - $script_name" \
           --menu "Please select an option:" 15 60 8 \
           1 "Find and install a Docker" \
           2 "Find and install RunesRepoHub Software" \
           3 "Find and use a Quick Installer for other software" \
           4 "Add Cronjobs Quickly" \
           5 "Docker-CnC Scripts" \
           6 "Quick Tools" \
           7 "Pre-Made VM Configs" \
           8 "Youtube Scripts" 2>"${INPUT}"

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
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$QUICK_TOOLS
            ;;
        7)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$PRE_MADE_VM_CONFIGS
            ;;
        8)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$YOUTUBE_SCRIPTS
            ;;
        *)
            dialog --title "Exiting" --msgbox "Thank you for using RRHQD. Support me via github https://github.com/RunesRepoHub/" 6 52
            clear
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
