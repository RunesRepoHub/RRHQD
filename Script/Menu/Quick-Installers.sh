#!/bin/bash
clear 
source ~/RRHQD/Core/Core.sh

# Display the menu options
function show_menu() {
    echo "Please select an option:"
    echo "1) Run the Tailscale Installer"
    echo "2) Run the Starship Installer"
    echo "3) Coming Soon"
    echo "4) Exit"
}

# Run the selected script
function run_script() {
    case $1 in
        1)
            bash ~/RRHQD/Script/Quick-Installers/Tailscale-Installer.sh
            ;;
        2)
            bash ~/RRHQD/Script/Quick-Installers/Starship-Installer.sh
            sleep 1
            source ~/.bashrc
            ;;
        3)
            bash ~/RRHQD/Script/Quick-Installers/
            ;;
        4)
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
    show_menu
    read -p "Enter your choice [1-4]: " choice
    run_script $choice
done

clear