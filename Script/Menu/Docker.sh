#!/bin/bash
clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Display the initial messages and menu options
function render_welcome_and_menu() {
    echo -e "${Green}Welcome To RRHQD (RunesRepoHub Quick Deploy)${NC}"
    echo -e "${Blue}Current Script: $script_name${NC}"
    echo
    echo -e "${Yellow}Run Installers${NC}"
    echo -e "${Green}This will easy and quickly install Dockers made by other companies and users${NC}"
    echo
}



# Display the menu options
function show_menu() {
    echo "Please select an option:"
    echo "1) Run Uptime-Kuma Installer"
    echo "2) Run Vaultwarden Installer"
    echo "3) Run Cloudflare Tunnel Installer"
    echo "4) Run MediaCMS Installer"
    echo "5) Run NTFY Installer"
    echo "6) Run MySQL Installer"
    echo "7) Run N8N Installer"
    echo "8) Run Postgres Installer"
    echo "9) Run CheckMK Installer"
    echo "10) Exit"
}

# Run the selected script
function run_script() {
    case $1 in
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
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$MYSQL
            ;;
        9)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$INSTALLER_FOLDER/$CHECKMK
            ;;
        10)
            echo -e "${Red}Exiting...${NC}"
            clear
            exit 0
            ;;
        *)
            echo -e "${Red}Invalid option. Please try again.${NC}"
            ;;
    esac
}

# Main loop
while true; do
    render_welcome_and_menu
    show_menu
    read -p "Enter your choice [1-9]: " choice
    run_script $choice
done