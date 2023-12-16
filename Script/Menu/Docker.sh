#!/bin/bash
clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Display the initial messages and menu options
function render_welcome_and_menu() {
    echo -e "${Green}Welcome To RRHQD (RunesRepoHub Quick Deploy)${NC}"
    echo -e "${Blue}Current Script: $script_name${NC}"
    echo
    echo -e "${Yellow}Run Uptime-Kuma Installer${NC}"
    echo -e "${Green}This will easy and quickly install Uptime-Kuma Docker made by other companies and users${NC}"
    echo
    echo -e "${Yellow}Run Vaultwarden Installer${NC}"
    echo -e "${Green}This will easy and quickly install Vaultwarden Docker made by other companies and users${NC}"
    echo
    echo -e "${Yellow}Run Cloudflare Tunnel Installer${NC}"
    echo -e "${Green}This will easy and quickly install Cloudflare Tunnel Docker made by other companies and users${NC}"
    echo
}



# Display the menu options
function show_menu() {
    echo "Please select an option:"
    echo "1) Run Uptime-Kuma Installer"
    echo "2) Run Vaultwarden Installer"
    echo "3) Run Cloudflare Tunnel Installer"
    echo "4) Run MediaCMS Installer"
    echo "5) Exit"
}

# Run the selected script
function run_script() {
    case $1 in
        1)
            bash ~/RRHQD/Script/Installers/Uptime-Kuma.sh
            ;;
        2)
            bash ~/RRHQD/Script/Installers/Vaultwarden.sh
            ;;
        3)
            bash ~/RRHQD/Script/Installers/Cloudflare-Tunnel.sh
            ;;
        4)
            bash ~/RRHQD/Script/Installers/MediaCMS.sh
            ;;
        5)
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
    read -p "Enter your choice [1-5]: " choice
    run_script $choice
done