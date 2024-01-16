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

# Define the folder to check for duplicates
folder_to_check="$YOUTUBE_AUDIO"

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
    # Check for duplicate files using 'fdupes' and delete them
    echo "Checking for duplicate files in $folder_to_check"
    fdupes -rdN "$folder_to_check"
    echo "Duplicate files have been cleaned up."
fi

