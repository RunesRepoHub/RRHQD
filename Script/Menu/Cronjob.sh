#!/bin/bash

clear
source ~/RRHQD/Core/Core.sh

hostname=$(hostname)
ip=$(hostname -I | cut -d' ' -f1)
script_name=$(basename "$0" .sh)

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy) - Cronjob Menu Running On $hostname ($ip)" \
           --title "Cronjob Menu - $script_name" \
           --menu "Pick what cronjob you want to add:" 15 60 4 \
           1 "Add a Nightly reboot at 4:45 am" \
           2 "Daily Midnight Update" \
           3 "Add a Reboot cron job for every Sunday at 00:00 am" \
           4 "Cronjob Manager" \
           5 "Add Cronmointer" \
           6 "Add Webp Converter to run every 20 minutes" \
           7 "Add Youtube Short Cleanup to run every 20 minutes" \
           8 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$REBOOT_EVERY_NIGHT
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$UPDATE_DAILY_MIDNIGHT
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$REBOOT_EVERY_SUNDAY
            ;;
        4)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$CRONJOB_MANAGER
            ;;
        5)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$ADD_CRONMOINTER
            ;;
        6)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$ADD_WEBP_CONVERTER
            ;;
        7)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$ADD_SHORT_CLEANUP
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

