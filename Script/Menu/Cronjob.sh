#!/bin/bash


clear
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy)" \
           --title "Cronjob Menu - $script_name" \
           --menu "Pick what cronjob you want to add:" 15 60 4 \
           1 "Add a Nightly reboot at 4:45 am" \
           2 "Daily Midnight Update" \
           3 "Add a Reboot cron job for every Sunday at 00:00 am" \
           4 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_TOOLS_DIR/$REBOOT_EVERY_NIGHT
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_TOOLS_DIR/$UPDATE_DAILY_MIDNIGHT
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_TOOLS_DIR/$REBOOT_EVERY_SUNDAY
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

