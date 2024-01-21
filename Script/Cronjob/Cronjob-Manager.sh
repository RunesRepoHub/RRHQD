#!/bin/bash

# Cronjob Manager Script
# This script provides a simple interface to manage, add, and remove cronjobs via /etc/crontab

CRONTAB_FILE="/etc/crontab"

# Function to display menu and get choice using dialog
show_menu() {
    menu_choice=$(dialog --title "Cronjob Manager" --menu "Choose an action:" 15 50 4 \
        1 "Add a new cronjob" \
        2 "Remove an existing cronjob" \
        3 "List current cronjobs" \
        4 "Go back to the main menu" 3>&1 1>&2 2>&3)
    
    if [ -z "$menu_choice" ]; then
        clear
        exit 0 # Exit the script if cancel is pressed or ESC is pressed
    fi

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

remove_cronjob() {
    local cronjobs=$(tail -n +7 "${CRONTAB_FILE}")
    local i=1
    local options=()

    while read -r line; do
        options+=($i "$line")
        ((i++))
    done <<< "$cronjobs"

    if [ ${#options[@]} -eq 0 ]; then
        dialog --title "Remove Cronjob" --msgbox "No cronjobs available to remove." 6 50
    else
        choice=$(dialog --title "Remove Cronjob" --menu "Select a cronjob to remove:" 15 70 6 "${options[@]}" 3>&1 1>&2 2>&3)

        if [ -n "$choice" ]; then
            choice=$((choice + 6)) # Offset for system cronjobs that are not displayed
            sed -i "${choice}d" "${CRONTAB_FILE}"
            dialog --title "Success" --msgbox "Cronjob removed successfully." 6 50
        else
            dialog --title "Notice" --msgbox "No cronjob selected." 6 50
        fi
    fi

    clear
}

# Function to list cronjobs with dialog interface
list_cronjobs() {
    cronjobs=$(tail -n +7 "${CRONTAB_FILE}")
    dialog --title "List of Cronjobs" --msgbox "$cronjobs" 20 70
    clear
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

