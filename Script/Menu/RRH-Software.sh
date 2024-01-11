#!/bin/bash


clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy)" \
           --title "Main Menu - $script_name" \
           --menu "Please select an option:" 15 60 6 \
           1 "Run the ACS Installer" \
           2 "Run the CnC-WebGUI Installer" \
           3 "Run the CnC-Agent Installer" \
           4 "Run the EWD Installer" \
           5 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash <(wget -qO- https://raw.githubusercontent.com/RunesRepoHub/ACS/Production/setup.sh)
            ;;
        2)
            bash <(wget -qO- https://raw.githubusercontent.com/RunesRepoHub/CnC-WebGUI/Production/Functions/Install.sh)
            ;;
        3)
            bash <(wget -qO- https://raw.githubusercontent.com/RunesRepoHub/CnC-Agent/Production/Install-Agent-Only.sh)
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

