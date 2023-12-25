#!/bin/bash

source ~/RRHQD/Core/Core.sh

echo -e "${Green}Adding reboot cron job...${NC}"

# Check if the reboot cron job already exists
if crontab -l | grep -q "45 4 \* \* \* /sbin/reboot"; then
    echo -e "${Red}Reboot cron job already exists. Aborting script.${NC}"
    exit 1
else
    # Add the reboot cron job
    (crontab -l 2>/dev/null; echo "45 4 * * * /sbin/reboot") | crontab -
    echo -e "${Green}Reboot cron job added successfully.${NC}"
fi

