#!/bin/bash
clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Display the initial messages and menu options
function render_welcome_and_menu() {
    echo -e "${Green}Welcome To RRHQD (RunesRepoHub Quick Deploy)${NC}"
    echo -e "${Blue}Current Script: $script_name${NC}"
    echo
    echo -e "${Green}Pick a script made by RunesRepoHub${NC}"
}

# Display the menu options
function show_menu() {
    echo "Please select an option:"
    echo "1) Run the ACS Installer"
    echo "2) Run the CnC-WebGUI Installer"
    echo "3) Run the CnC-Agent Installer"
    echo "4) Run the EWD Installer"
    echo "5) Exit"
}

# Run the selected script
function run_script() {
    case $1 in
        1)
            bash <(wget -qO- https://raw.githubusercontent.com/RunesRepoHub/ACS/Production/setup.sh)
            ;;
        2)
            bash <(wget -qO- https://raw.githubusercontent.com/RunesRepoHub/CnC-WebGUI/Production/Functions/Install.sh)
            ;;
        3)
            bash <(wget -qO- https://raw.githubusercontent.com/RunesRepoHub/CnC-Agent/Production/Install-Agent-Only.sh)
            ;;
        4)
            bash <(wget -qO- https://raw.githubusercontent.com/RunesRepoHub/EWD/Production/Setup.sh)
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
    read -p "Enter your choice [1-4]: " choice
    run_script $choice
done
