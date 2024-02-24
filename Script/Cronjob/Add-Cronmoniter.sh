#!/bin/bash

source ~/RRHQD/Core/Core.sh

CRONTAB_FILE="/etc/crontab"

# Function to ask the user for the command to be run every 20 minutes
add_cronjob() {
    command=$(dialog --title "Cronjob Command" --inputbox "Please enter the command to be run every 20 minutes:" 8 50 3>&1 1>&2 2>&3)
    user=$(whoami)

    cronjob="*/20 * * * * $user $command"

    if echo "$cronjob" | sudo tee -a "$CRONTAB_FILE" >/dev/null; then
        dialog --title "Success" --msgbox "Cronjob added successfully." 6 50
    else
        dialog --title "Failure" --msgbox "Failed to add cronjob." 6 50
        return 1
    fi
}

# Call the function to add the cron job
add_cronjob
