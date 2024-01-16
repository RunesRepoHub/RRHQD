#!/bin/bash



clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy)" - Quick-Installers \
           --title "Main Menu - $script_name" \
           --menu "Please select an option:" 15 60 6 \
           1 "Run the Tailscale Installer" \
           2 "Run the Starship Installer" \
           3 "Run the Filezilla Installer" \
           4 "Run the Fail2Ban Installer" \
           5 "Run the Ansible Installer" \
           6 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_INSTALLERS_DIR/$TAILSCALE
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_INSTALLERS_DIR/$STARSHIP
            sleep 1
            source ~/.bashrc
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_INSTALLERS_DIR/$FILEZILLA
            ;;
        4)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_INSTALLERS_DIR/$FAIL2BAN
            ;;
        5)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_INSTALLERS_DIR/$ANSIBLE
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

