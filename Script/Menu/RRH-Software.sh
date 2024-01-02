#!/bin/bash
clear
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Define the input file for dialog selections
INPUT=/tmp/menu.sh.$$

# Display the menu options using dialog
function show_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy)" \
           --title "Main Menu - $script_name" \
           --menu "Please select an option:" 15 60 5 \
           1 "Run the ACS Installer" \
           2 "Run the CnC-WebGUI Installer" \
           3 "Run the CnC-Agent Installer" \
           4 "Run the EWD Installer" \
           5 "Exit" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    echo "$menu_choice"
}

# Run the selected script
function run_script() {
    case $1 in
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

# Main loop
while true; do
    choice=$(show_menu)
    run_script "$choice"
done

# Cleanup temp file
[ -f $INPUT ] && rm $INPUT

