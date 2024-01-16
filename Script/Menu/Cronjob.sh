#!/bin/bash

clear
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

function show_options_menu() {
    echo "Cronjob Menu - $script_name"
    echo "Pick what cronjob you want to add:"
    echo "1) Add a Nightly reboot at 4:45 am"
    echo "2) Daily Midnight Update"
    echo "3) Add a Reboot cron job for every Sunday at 00:00 am"
    echo "4) Back To Main Menu"
    echo -n "Please enter your choice: "
    read menu_choice

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
        *)
            ;;
    esac
}

# Main loop
while true; do
    show_options_menu
done

