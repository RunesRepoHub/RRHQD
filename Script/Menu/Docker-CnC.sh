#!/bin/bash
# RRHQD/Script/Menu/Docker-CnC.sh

clear 
source ~/RRHQD/Core/Core.sh

# Define the script name
script_name=$(basename "$0" .sh)

# Display the initial messages and menu options
function render_welcome_and_menu() {
    echo -e "${Green}Welcome To RRHQD (RunesRepoHub Quick Deploy) - Docker-CnC${NC}"
    echo -e "${Blue}Current Script: $script_name${NC}"
    echo
    echo -e "${Green}Select a Docker-CnC script to run${NC}"
    echo
}

# Display the menu options
function show_menu() {
    echo "Please select an option:"
    echo "1) Docker - Cleanup"
    echo "2) Docker - Start"
    echo "3) Docker - Stop"
    echo "4) Docker - Update"
    echo "5) Exit"
}

# Run the selected script
function run_script() {
    case $1 in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$DOCKER_CNC_FOLDER/$DOCKER_CLEANUP
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$DOCKER_CNC_FOLDER/$DOCKER_START
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$DOCKER_CNC_FOLDER/$DOCKER_STOP
            ;;
        4)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$DOCKER_CNC_FOLDER/$DOCKER_UPDATE
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
