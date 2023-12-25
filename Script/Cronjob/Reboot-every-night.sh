#!/bin/bash

source ~/RRHQD/Core/Core.sh

echo -e "${Green}Adding reboot cron job...${NC}"

# Check if the reboot cron job already exists in /etc/crontab
if grep -q "45 4 \* \* \* root /sbin/reboot" /etc/crontab; then
    echo -e "${Red}Reboot cron job already exists in /etc/crontab. Aborting script.${NC}"
    exit 1
else
    # Add the reboot cron job to /etc/crontab
    echo "45 4 * * * root /sbin/reboot" >> /etc/crontab
    echo -e "${Green}Reboot cron job added to /etc/crontab successfully.${NC}"
fi

