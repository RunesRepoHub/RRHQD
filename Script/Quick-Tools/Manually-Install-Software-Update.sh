#!/bin/bash

DOWNLOAD_DIR=~/Downloads
DEB_FILES=($(ls "$DOWNLOAD_DIR"/*.deb))

if [ ${#DEB_FILES[@]} -eq 0 ]; then
    echo "No .deb installation files found in the download directory."
    exit 1
fi

echo "Select the .deb file you wish to install:"

for i in "${!DEB_FILES[@]}"; do
    echo "$((i+1))) ${DEB_FILES[$i]}"
done

read -p "Enter the number (e.g., 1): " USER_CHOICE

# Subtract 1 to get the array index
USER_CHOICE_INDEX=$((USER_CHOICE-1))

# Validate user input
if [[ $USER_CHOICE_INDEX -ge 0 && $USER_CHOICE_INDEX -lt ${#DEB_FILES[@]} ]]; then
    FILE_TO_INSTALL=${DEB_FILES[$USER_CHOICE_INDEX]}
    echo "Installing $FILE_TO_INSTALL..."
    sudo dpkg -i "$FILE_TO_INSTALL"
    sudo apt-get install -f # Install any dependencies that might be missing
else
    echo "Invalid selection. Exiting."
fi
