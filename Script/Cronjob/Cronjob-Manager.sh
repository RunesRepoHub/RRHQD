#!/bin/bash

# Check if zenity is installed, if not, install it
if ! command -v zenity &> /dev/null; then
    echo "Zenity is not installed. Attempting to install Zenity..."
    sudo apt-get update && sudo apt-get install -y zenity
    if ! command -v zenity &> /dev/null; then
        echo "Failed to install Zenity. Aborting script."
        exit 1
    fi
    echo "Zenity has been successfully installed."
else
    echo "Zenity is already installed."
fi

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

# Function to add a cronjob with GUI interface for easier input
add_cronjob() {
    minute=$(zenity --entry --title="Cronjob Minute" --text="Minute (0-59):")
    hour=$(zenity --entry --title="Cronjob Hour" --text="Hour (0-23):")
    day=$(zenity --entry --title="Cronjob Day of Month" --text="Day of Month (1-31):")
    month=$(zenity --entry --title="Cronjob Month" --text="Month (1-12):")
    dow=$(zenity --list --title="Cronjob Day of Week" --text="Day of Week:" --column="Day" "0 (Sunday)" "1 (Monday)" "2 (Tuesday)" "3 (Wednesday)" "4 (Thursday)" "5 (Friday)" "6 (Saturday)" --hide-header)
    user=$(zenity --entry --title="Cronjob User" --text="User:")
    command=$(zenity --entry --title="Cronjob Command" --text="Command:")

    cronjob="${minute} ${hour} ${day} ${month} ${dow:0:1} ${user} ${command}"

    if echo "${cronjob}" >> "${CRONTAB_FILE}"; then
        zenity --info --title="Success" --text="Cronjob added successfully."
    else
        zenity --error --title="Failure" --text="Failed to add cronjob."
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

