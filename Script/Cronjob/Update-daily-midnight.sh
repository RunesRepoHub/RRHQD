#!/bin/bash
source ~/RRHQD/Core/Core.sh

echo -e "${Green}Adding update cron job...${NC}"

add_update_cronjob() {
    local update_command="apt-get update && apt-get upgrade -y"
    local cronjob_entry="0 0 * * * root $update_command"

    # Check if the update cron job already exists in /etc/crontab
    if grep -qF -- "$update_command" /etc/crontab; then
        echo -e "${Red}Update cron job already exists in /etc/crontab. No changes made.${NC}"
    else
        # Add the update cron job to /etc/crontab
        if echo "$cronjob_entry" >> /etc/crontab; then
            echo -e "${Green}Update cron job added to /etc/crontab successfully.${NC}"
        else
            echo -e "${Red}Failed to add update cron job to /etc/crontab.${NC}"
            return 1
        fi
    fi
}

# Call the function to add the cron job
add_update_cronjob

