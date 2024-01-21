#!/bin/bash

# Cronjob Manager Script
# This script provides a dialog interface to manage, add, and remove cronjobs via /etc/crontab

CRONTAB_FILE="/etc/crontab"

# Function to display menu using dialog
show_menu() {
    dialog --clear --backtitle "Cronjob Manager" \
        --title "Main Menu" \
        --menu "Choose an action:" 15 50 4 \
        "Add" "Add a new cronjob" \
        "Remove" "Remove an existing cronjob" \
        "List" "List current cronjobs" \
        "Exit" "Exit the script" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    echo $menu_choice
}

# Function to add a cronjob
add_cronjob() {
    dialog --title "Add a cronjob" --form "\nEnter the new cronjob details:" \
    15 50 0 \
    "Minute:" 1 1 "" 1 10 40 0 \
    "Hour:" 2 1 "" 2 10 40 0 \
    "Day of Month:" 3 1 "" 3 10 40 0 \
    "Month:" 4 1 "" 4 10 40 0 \
    "Day of Week:" 5 1 "" 5 10 40 0 \
    "User:" 6 1 "" 6 10 40 0 \
    "Command:" 7 1 "" 7 10 40 0 2>"${INPUT}"

    IFS="|" read -r minute hour day month dow user command < "${INPUT}"
    cronjob="${minute} ${hour} ${day} ${month} ${dow} ${user} ${command}"

    if echo "${cronjob}" >> "${CRONTAB_FILE}"; then
        dialog --msgbox "Cronjob added successfully." 6 50
    else
        dialog --msgbox "Failed to add cronjob." 6 50
    fi
}

# Function to remove a cronjob
remove_cronjob() {
    local cronjobs=$(tail -n +7 "${CRONTAB_FILE}")
    local cronjob_list=()
    local i=1

    while read -r line; do
        cronjob_list+=("$i" "$line")
        let i++
    done <<< "$cronjobs"

    dialog --clear --backtitle "Cronjob Manager" \
        --title "Remove a cronjob" \
        --menu "Select a cronjob to remove:" 15 80 6 \
        "${cronjob_list[@]}" 2>"${INPUT}"

    local choice=$(<"${INPUT}")

    if [[ -n $choice ]]; then
        sed -i "${choice}d" "${CRONTAB_FILE}"
        dialog --msgbox "Cronjob removed successfully." 6 50
    else
        dialog --msgbox "No cronjob selected." 6 50
    fi
}

# Function to list cronjobs
list_cronjobs() {
    dialog --textbox "${CRONTAB_FILE}" 22 80
}

# Check if dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "dialog is not installed. Please install it to run this script."
    exit 1
fi

# Check if the user is root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Input file for dialog responses
INPUT=$(mktemp)

# Main loop
while true; do
    choice=$(show_menu)
    case $choice in
        Add)
            add_cronjob
            ;;
        Remove)
            remove_cronjob
            ;;
        List)
            list_cronjobs
            ;;
        Exit)
            break
            ;;
        *)
            dialog --msgbox "Invalid choice." 6 50
            ;;
    esac
done

# Clean up
clear
[ -f "$INPUT" ] && rm "$INPUT"
