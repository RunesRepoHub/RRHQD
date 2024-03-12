#!/bin/bash

source ~/RRHQD/Core/Core.sh

chmod +x $ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND/$WEBP_TO_JPEG

add_update_cronjob() {
    local update_command="$ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND/$WEBP_TO_JPEG"
    local cronjob_entry="0 0 * * * root bash $update_command"

    # Check if the update cron job already exists in /etc/crontab
    if grep -qF -- "$update_command" /etc/crontab; then
        dialog --msgbox "Update cron job already exists in /etc/crontab. No changes made." 6 50
    else
        # Add the update cron job to /etc/crontab
        if echo "$cronjob_entry" >> /etc/crontab; then
            dialog --msgbox "Update cron job added to /etc/crontab successfully." 6 50
        else
            dialog --msgbox "Failed to add update cron job to /etc/crontab." 6 50
            return 1
        fi
    fi
}

# Call the function to add the cron job
add_update_cronjob