#!/bin/bash

source ~/RRHQD/Core/Core.sh

# Source Core.sh script if it exists, otherwise exit the script
if [ -f ~/ACS/ACSF-Scripts/Core.sh ]; then
  source ~/ACS/ACSF-Scripts/Core.sh
else
  dialog --title "Error" --msgbox "Core.sh script not found. Exiting." 6 50
  exit 0
fi

ROOT_FOLDER=~/RRHQD

# Use dialog to get the folder to scan from the user
folder_choice=$(dialog --title "Select Folder" --menu "Choose the folder to scan:" 15 40 2 \
    1 "YOUTUBE" \
    2 "YOUTUBE_AUDIO" 3>&1 1>&2 2>&3)

# Set the folder_to_scan variable based on user selection
case $folder_choice in
    1)
        folder_to_scan=$YOUTUBE
        ;;
    2)
        folder_to_scan=$YOUTUBE_AUDIO
        ;;
    *)
        dialog --title "Error" --msgbox "Invalid selection. Exiting." 6 50
        exit 1
        ;;
esac

# Inform the user of the selected folder
dialog --title "Folder Selection" --msgbox "Selected folder: $folder_to_scan" 6 50

# Use dialog to get the path to check for duplicates
folder_to_check=$(dialog --title "Path Selection" --inputbox "Enter the path to check for duplicates:" 8 50 3>&1 1>&2 2>&3)

# Install 'fdupes' if not already installed
if ! command -v fdupes &> /dev/null; then
    dialog --title "fdupes Installation" --infobox "fdupes is not installed. Attempting to install fdupes..." 4 50
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get install fdupes || exit 1
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install fdupes || exit 1
    else
        dialog --title "Error" --msgbox "Unsupported operating system. Please install fdupes manually." 6 50
        exit 1
    fi
    dialog --title "Installation Successful" --msgbox "fdupes has been installed. Re-run the script to clean up duplicates." 6 50
else
    # Check for duplicate files including subdirectories using 'fdupes' and delete them
    dialog --title "Duplicate File Check" --infobox "Checking for duplicate files in $folder_to_check and its subfolders." 4 50
    fdupes -rdN --recurse "$folder_to_check"
    dialog --title "Cleanup Complete" --msgbox "Duplicate files including those in subfolders have been cleaned up." 6 50
fi

