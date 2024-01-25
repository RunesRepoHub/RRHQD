#!/bin/bash
# Capture the current user's username
USERNAME=$(whoami)
# Get system distribution and version information
SYSTEM_INFO=$(lsb_release -d | cut -f2)
# Get the current date and time
DATE_TIME=$(date +"%Y-%m-%d %H:%M:%S")
# Send the data to the server using HTTP
curl -X POST -H "Priority: low" -d "The user $USERNAME has just run RRHQD Setup.sh on $SYSTEM_INFO at time: $DATE_TIME" https://notify.rp-helpdesk.com/RRHQD-Github-Analytics
