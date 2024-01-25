#!/bin/bash
# Attempt to find the download directory even if the system language is not English
DOWNLOAD_DIR=$(xdg-user-dir DOWNLOAD 2>/dev/null || echo "$HOME/Downloads")

DEB_FILES=($(ls "$DOWNLOAD_DIR"/*.deb))

if [ ${#DEB_FILES[@]} -eq 0 ]; then
    dialog --title "Installation Error" --msgbox "No .deb installation files found in the download directory." 6 50
    exit 1
fi

# Use dialog to create a menu for file selection
FILE_MENU=()
for i in "${!DEB_FILES[@]}"; do
    FILE_MENU+=($((i+1)) "${DEB_FILES[$i]}")
done

USER_CHOICE=$(dialog --title "Select .deb file to install" --menu "Choose a file:" 15 60 4 "${FILE_MENU[@]}" 3>&1 1>&2 2>&3)

# Exit status of dialog
STATUS=$?
# Close the dialog box if the user pressed Cancel or Esc
if [ $STATUS -eq 1 ] || [ $STATUS -eq 255 ]; then
    clear
    echo "Installation canceled by user."
    exit 1
fi

# Subtract 1 to get the array index
USER_CHOICE_INDEX=$((USER_CHOICE-1))

# Validate user input
if [[ $USER_CHOICE_INDEX -ge 0 && $USER_CHOICE_INDEX -lt ${#DEB_FILES[@]} ]]; then
    FILE_TO_INSTALL=${DEB_FILES[$USER_CHOICE_INDEX]}
    dialog --title "Installing" --infobox "Installing $FILE_TO_INSTALL..." 5 70
    sudo dpkg -i "$FILE_TO_INSTALL"
    sudo apt-get install -f # Install any dependencies that might be missing
    dialog --title "Installation Complete" --msgbox "$FILE_TO_INSTALL installed successfully." 6 50
else
    dialog --title "Invalid Selection" --msgbox "Invalid selection. Exiting." 6 50
fi

# Clear the screen after the installation
clear

