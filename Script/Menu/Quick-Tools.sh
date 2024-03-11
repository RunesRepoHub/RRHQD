#!/bin/bash



clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy) - Quick-Tools Menu Running On $hostname ($ip)" \
           --title "Quick Tools Menu - $script_name" \
           --menu "Please select a tool to run:" 15 60 4 \
           1 "Disk Check" \
           2 "Security Check" \
           3 "Vulnerability Check" \
           4 "Full Scan Check" \
           5 "Update Software Via deb Files" \
           6 "ACS Cleanup" \
           7 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_TOOLS_DIR/$DISK_CHECK
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_TOOLS_DIR/$SECURITY_CHECK
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_TOOLS_DIR/$VULNERABILITY_CHECK
            ;;
        4)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_TOOLS_DIR/$FULL_SCAN_CHECK
            ;;
        5)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_TOOLS_DIR/$MANUALLY_INSTALL_SOFTWARE_UPDATE
            ;;
        6)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_TOOLS_DIR/$DISK_CLEANUP
            ;;
        *)
            exit 0
            ;;
    esac
}

# Define the input file for dialog selections
INPUT=/tmp/menu.sh.$$

# Ensure the temp file is removed upon script termination
trap "rm -f $INPUT" 0 1 2 5 15

# Main loop
while true; do
    show_dialog_menu
done
