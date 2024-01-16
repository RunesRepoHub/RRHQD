#!/bin/bash

source ~/RRHQD/Core/Core.sh

echo -e "${Green}Checking for existing reboot cron job...${NC}"

cronjob_entry="45 4 * * * root /sbin/reboot"

# Check if the reboot cron job already exists in /etc/crontab
if grep -qF -- "$cronjob_entry" /etc/crontab; then
    echo -e "${Red}Reboot cron job already exists in /etc/crontab. Aborting script.${NC}"
    exit 1
else
    # Add the reboot cron job to /etc/crontab
    echo "$cronjob_entry" >> /etc/crontab
    echo -e "${Green}Reboot cron job added to /etc/crontab successfully.${NC}"
fi


# Get the current username
current_user=$(whoami)

# Append cron job to /etc/crontab for Ubuntu user
cronjob_entry_ubuntu="45 4 * * * $current_user /sbin/reboot"

if ! grep -qF -- "$cronjob_entry_ubuntu" /etc/crontab; then
    echo "$cronjob_entry_ubuntu" | sudo tee -a /etc/crontab > /dev/null
    echo -e "${Green}Cron job for Ubuntu user added to /etc/crontab successfully.${NC}"
else
    echo -e "${Red}Cron job for Ubuntu user already exists in /etc/crontab. No changes made.${NC}"
fi
