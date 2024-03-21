#!/bin/bash

source ~/RRHQD/Core/Core.sh

CRONTAB_FILE="/etc/crontab"
command="bash $ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND_FOLDER/$ADD_AUTOMATED_SHOW_NODE"

# Function to ask the user for the command to be run every 20 minutes
add_cronjob() {
    user=$(whoami)

    cronjob="30 4 * * SUN $user $command"

    if echo "$cronjob" | sudo tee -a "$CRONTAB_FILE" >/dev/null; then
        dialog --title "Success" --msgbox "Cronjob added successfully." 6 50
    else
        dialog --title "Failure" --msgbox "Failed to add cronjob." 6 50
        return 1
    fi
}

# Call the function to add the cron job
add_cronjob
