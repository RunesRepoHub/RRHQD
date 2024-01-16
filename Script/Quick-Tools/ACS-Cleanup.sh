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

# Ask the user to choose which folder to scan
echo "Choose the folder to scan:"
echo "1) YOUTUBE"
echo "2) YOUTUBE_AUDIO"
read -p "Selection (1 or 2): " folder_choice

case $folder_choice in
    1)
        folder_to_scan=$YOUTUBE
        ;;
    2)
        folder_to_scan=$YOUTUBE_AUDIO
        ;;
    *)
        echo "Invalid selection. Exiting."
        exit 1
        ;;
esac

# Continue with operations on the selected folder
echo "Selected folder: $folder_to_scan"

# Ask the user for the path to check
read -p "Enter the path to check for duplicates: " folder_to_check

# Install 'fdupes' if not already installed
if ! command -v fdupes > /dev/null; then
    echo "fdupes is not installed. Attempting to install fdupes..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get install fdupes || exit 1
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install fdupes || exit 1
    else
        echo "Unsupported operating system. Please install fdupes manually."
        exit 1
    fi
    echo "fdupes has been installed. Re-run the script to clean up duplicates."
else
    # Check for duplicate files including subdirectories using 'fdupes' and delete them
echo "Checking for duplicate files in $folder_to_check and its subfolders"
fdupes -rdN --recurse "$folder_to_check"
echo "Duplicate files including those in subfolders have been cleaned up."
fi

