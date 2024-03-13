#!/bin/bash


clear 
source ~/RRHQD/Core/Core.sh

hostname=$(hostname)
ip=$(hostname -I | cut -d' ' -f1)
script_name=$(basename "$0" .sh)

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy) - RRH-Software Menu Running On $hostname ($ip)" \
           --title "Main Menu - $script_name" \
           --menu "Please select an option:" 15 60 6 \
           1 "Run the ACS Installer" \
           2 "News Report Docker Installer" \
           3 "Coming Soon" \
           4 "Run the EWD Installer" \
           5 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            chmod +x ~/RRHQD/Core/ACS-Core.sh
            chmod +x $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS/$ACS_SCRIPT_FOLDER/$ACS_SETUP
            bash  $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS/$ACS_SCRIPT_FOLDER/$ACS_SETUP
            ;;
        2)
            bash <(wget -qO- https://raw.githubusercontent.com/RunesRepoHub/NRD/Production/Setup.sh)
            ;;
        3)
            
            ;;
        4)
            bash <(wget -qO- https://raw.githubusercontent.com/RunesRepoHub/EWD/Production/Setup.sh)
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

