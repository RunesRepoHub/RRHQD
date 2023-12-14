#!/bin/bash
clear 
source ~/RRHQD/Core/Core.sh

# Display the menu options
function show_menu() {
    echo "Please select an option:"
    echo "1) Find a Docker"
    echo "2) Coming Soon"
    echo "3) Coming Soon"
    echo "4) Coming Soon"
    echo "5) Update"
    echo "6) Exit"
}

# Run the selected script
function run_script() {
    case $1 in
        1)
            bash ~/RRHQD/Script/Menu/Docker.sh ## Dockers
            ;;
        2)
            echo -e "Coming Soon" ## RunesRepoHub 
            ;;
        3)
            echo -e "Coming Soon" ## Quick Installers
            ;;
        4)
            echo -e "Coming Soon" ## Open Spot
            ;;
        5)
            echo -e "${Green}Updating...${NC}"
            cd ~/RRHQD
            git pull
            exit 0
            clear
            bash ~/RRHQD/Script/Menu/Main-Menu.sh
            ;;
        6)
            echo -e "${Red}Exiting...${NC}"
            exit 0
            clear
            ;;
        *)
            echo -e "${Red}Invalid option. Please try again.${NC}"
            ;;
    esac
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice [1-6]: " choice
    run_script $choice
done

clear