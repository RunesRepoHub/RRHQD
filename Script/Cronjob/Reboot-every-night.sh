#!/bin/bash

source ~/RRHQD/Core/Core.sh

echo -e "${Green}Checking for existing reboot cron job...${NC}"

# Determine the current user for the cron job
current_user=$(whoami)

# Set the cron job entry for reboot
cronjob_entry="45 4 * * * $current_user /sbin/reboot"

# Function to add cron job entry to user's own crontab
add_user_cron_job() {
    # Check if the reboot cron job already exists in the user's crontab
    if crontab -l | grep -qF -- "$cronjob_entry"; then
        echo -e "${Red}Reboot cron job already exists. Aborting script.${NC}"
        exit 1
    else
        # Add the reboot cron job to the user's crontab
        (crontab -l 2>/dev/null; echo "$cronjob_entry") | crontab -
        echo -e "${Green}Reboot cron job added successfully.${NC}"
    fi
}

# Call the function to add the cron job
add_user_cron_job

