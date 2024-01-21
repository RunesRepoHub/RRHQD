#!/bin/bash

# Cronjob Manager Script
# This script provides a simple interface to manage, add, and remove cronjobs via /etc/crontab

CRONTAB_FILE="/etc/crontab"

# Function to display menu
show_menu() {
    echo "Cronjob Manager"
    echo "1. Add a new cronjob"
    echo "2. Remove an existing cronjob"
    echo "3. List current cronjobs"
    echo "4. Exit the script"
    echo -n "Choose an action [1-4]: "
    read -r menu_choice
    echo "$menu_choice"
}

# Function to add a cronjob
add_cronjob() {
    read -p "Minute: " minute
    read -p "Hour: " hour
    read -p "Day of Month: " day
    read -p "Month: " month
    read -p "Day of Week: " dow
    read -p "User: " user
    read -p "Command: " command
    cronjob="${minute} ${hour} ${day} ${month} ${dow} ${user} ${command}"

    if echo "${cronjob}" >> "${CRONTAB_FILE}"; then
        echo "Cronjob added successfully."
    else
        echo "Failed to add cronjob."
    fi
}

# Function to remove a cronjob
remove_cronjob() {
    local cronjobs=$(tail -n +7 "${CRONTAB_FILE}")
    local i=1
    echo "Select a cronjob to remove:"

    while read -r line; do
        echo "$i. $line"
        ((i++))
    done <<< "$cronjobs"

    read -p "Enter number of cronjob to remove: " choice

    if [[ -n $choice ]]; then
        sed -i "${choice}d" "${CRONTAB_FILE}"
        echo "Cronjob removed successfully."
    else
        echo "No cronjob selected."
    fi
}

# Function to list cronjobs
list_cronjobs() {
    echo "Current cronjobs:"
    cat "${CRONTAB_FILE}"
}

# Check if the user is root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Main loop
while true; do
    choice=$(show_menu)
    case "$choice" in
        1)
            add_cronjob
            ;;
        2)
            remove_cronjob
            ;;
        3)
            list_cronjobs
            ;;
        4)
            break
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
done

# Clean up
clear

