#!/bin/bash



clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy) - Dockers Menu Running On $hostname ($ip)" \
           --title "Main Menu - $script_name" \
           --menu "Please select an option:" 15 60 12 \
           1 "Run Uptime-Kuma Installer" \
           2 "Run Vaultwarden Installer" \
           3 "Run Cloudflare Tunnel Installer" \
           4 "Run MediaCMS Installer" \
           5 "Run NTFY Installer" \
           6 "Run MySQL Installer" \
           7 "Run N8N Installer" \
           8 "Run Postgres Installer" \
           9 "Run CheckMK Installer" \
           10 "Run the llama-gpt Installer" \
           11 "Run Portainer Installer" \
           12 "Run Deluge Installer" \
           13 "Run Ghost Installer" \
           14 "Run Linkwarden Installer" \
           15 "Run Memos Installer" \
           16 "Run It-tools Installer" \
           17 "Run Sonarr Installer" \
           18 "Run Radarr Installer" \
           19 "Run Ombi Installer" \
           20 "Run Jackett Installer" \
           21 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$UPTIME_KUMA
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$VAULTWARDEN
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$CLOUDFLARE_TUNNEL
            ;;
        4)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$MEDIACMS
            ;;
        5)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$NTFY
            ;;
        6)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$MYSQL
            ;;
        7)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$N8N
            ;;
        8)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$POSTGRES
            ;;
        9)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$CHECKMK
            ;;
        10)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$LLAMA_GPT
            ;;
        11)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$PORTAINER
            ;;
        12)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$DELUGE
            ;;
        13)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$GHOST
            ;;
        14)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$LINKWARDEN
            ;;
        15)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$MEMOS
            ;;
        16)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$IT_TOOLS
            ;;
        17)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$SONARR
            ;;
        18)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$RADARR
            ;;
        19)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$OMBI
            ;;
        20)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$JACKETT
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
