#!/bin/bash

source ~/RRHQD/Core/Core.sh

clear

script_name=$(basename "$0" .sh)

function show_dialog_menu() {
    dialog --clear
    dialog --backtitle "RRHQD (RunesRepoHub Quick Deploy) - Pre-Made-VM-Configs" \
           --title "Main Menu - $script_name" \
           --menu "Please select an option:" 15 60 8 \
           1 "Run the RP-Helpdesk Standard Config" \
           2 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")

    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$PRE_MADE_VM_CONFIGS_DIR/$PRE_MADE_VM
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