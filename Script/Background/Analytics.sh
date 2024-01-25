#!/bin/bash

# Use dialog to prompt the user for their GitHub username
USERNAME=$(dialog --title "Username" --inputbox "Enter your username:" 8 50 3>&1 1>&2 2>&3)

# Check if the USERNAME variable is empty
if [ -z "$USERNAME" ]; then
    echo "No GitHub username entered. Exiting script."
    exit 1
fi

# Exit if the user canceled the dialog
if [ $? -ne 0 ]; then
    exit 1
fi

# Get system distribution and version information
SYSTEM_INFO=$(lsb_release -d | cut -f2)

# Get the current date and time
DATE_TIME=$(date +"%Y-%m-%d %H:%M:%S")

# Send the data to the server using HTTP
curl -X POST -H "Priority: low" -d "The user $USERNAME has just run RRHQD Setup.sh on $SYSTEM_INFO at time: $DATE_TIME" https://notify.rp-helpdesk.com/RRHQD-Analytics
