#!/bin/bash

source ~/RRHQD/Core/Core.sh

echo -e "${Green}Checking for existing reboot cron job...${NC}"

cronjob_entry="45 4 * * * root /sbin/reboot"

# Check if the reboot cron job already exists in /etc/crontab
if grep -qF -- "$cronjob_entry" /etc/crontab; then
    dialog --msgbox "Reboot cron job already exists in /etc/crontab. Aborting script." 10 50
    exit 1
else
    # Add the reboot cron job to /etc/crontab
    echo "$cronjob_entry" >> /etc/crontab
    dialog --msgbox "Reboot cron job added to /etc/crontab successfully." 10 50
fi

