#!/bin/bash

# Cronjob Manager Script
# This script provides a simple interface to manage, add, and remove cronjobs via /etc/crontab

CRONTAB_FILE="/etc/crontab"

# Function to display menu and get choice
show_menu() {
    echo "Cronjob Manager"
    echo "1. Add a new cronjob"
    echo "2. Remove an existing cronjob"
    echo "3. List current cronjobs"
    echo "4. Exit the script"
    echo -n "Choose an action [1-4]: "
    read -r menu_choice
    return "$menu_choice"
}

# Function to add a cronjob with dialog interface for easier input
add_cronjob() {
    minute=$(dialog --title "Cronjob Minute" --inputbox "Minute (0-59):" 8 40 2>&1 >/dev/tty)
    hour=$(dialog --title "Cronjob Hour" --inputbox "Hour (0-23):" 8 40 2>&1 >/dev/tty)
    day=$(dialog --title "Cronjob Day of Month" --inputbox "Day of Month (1-31):" 8 40 2>&1 >/dev/tty)
    month=$(dialog --title "Cronjob Month" --inputbox "Month (1-12):" 8 40 2>&1 >/dev/tty)
    dow=$(dialog --title "Cronjob Day of Week" --menu "Day of Week:" 15 50 7 \
        0 "Sunday" \
        1 "Monday" \
        2 "Tuesday" \
        3 "Wednesday" \
        4 "Thursday" \
        5 "Friday" \
        6 "Saturday" 2>&1 >/dev/tty)
    user=$(dialog --title "Cronjob User" --inputbox "User:" 8 40 2>&1 >/dev/tty)
    command=$(dialog --title "Cronjob Command" --inputbox "Command:" 8 40 2>&1 >/dev/tty)

    cronjob="${minute} ${hour} ${day} ${month} ${dow} ${user} ${command}"

    if echo "${cronjob}" >> "${CRONTAB_FILE}"; then
        dialog --title "Success" --msgbox "Cronjob added successfully." 6 50
    else
        dialog --title "Failure" --msgbox "Failed to add cronjob." 6 50
    fi

    clear
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
    choice=$((choice + 6)) # Offset for system cronjobs that are not displayed

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
    tail -n +7 "${CRONTAB_FILE}"
}

# Check if the user is root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Main loop
while true; do
    show_menu
    choice=$?

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

