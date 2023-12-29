#!/bin/bash

source ~/RRHQD/Core/Core.sh

echo -e "${Green}Adding reboot cron job for every Sunday...${NC}"

# Check if the reboot cron job already exists in /etc/crontab
if grep -q "0 0 * * 0 root /sbin/reboot" /etc/crontab; then
    echo -e "${Red}Reboot cron job for every Sunday already exists in /etc/crontab. Aborting script.${NC}"
    exit 1
else
    # Add the reboot cron job to /etc/crontab for every Sunday at 00:00
    echo "0 0 * * 0 root /sbin/reboot" >> /etc/crontab
    echo -e "${Green}Reboot cron job for every Sunday added to /etc/crontab successfully.${NC}"
fi

