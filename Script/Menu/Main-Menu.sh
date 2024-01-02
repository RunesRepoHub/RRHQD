#!/bin/bash
clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Display the initial messages and menu options
function render_welcome_and_menu() {
    echo -e "${Green}Welcome To RRHQD (RunesRepoHub Quick Deploy)${NC}"
    echo -e "${Blue}Current Script: $script_name${NC}"
    echo
    echo -e "${Yellow}Find and install a Docker${NC}"
    echo -e "${Green}This will easy and quickly install Docker made by other companies and users${NC}"
    echo
    echo -e "${Yellow}Find and install RunesRepoHub Software${NC}"
    echo -e "${Green}This will easy and quickly install RunesRepoHub Software made by RunesRepoHub${NC}"
    echo
    echo -e "${Yellow}Find and use a Quick Installer for other software${NC}"
    echo -e "${Green}This will easy and quickly install software made by other compaines and users${NC}"
    echo
    echo -e "${Yellow}Add Cronjobs Quickly${NC}"
    echo -e "${Green}This will easy and quickly add cronjobs${NC}"
    echo
    echo -e "${Yellow}Update${NC}"
    echo -e "${Green}This will update the all scripts used in RRHQD${NC}"
    echo
}

# Display the menu options
function show_menu() {
    echo "Please select an option:"
    echo "1) Find and install a Docker"
    echo "2) Find and install RunesRepoHub Software"
    echo "3) Find and use a Quick Installer for other software"
    echo "4) Add Cronjobs Quickly"
    echo "5) Update"
    echo "6) Exit"
}

# Run the selected script
function run_script() {
    case $1 in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$DOCKER ## Dockers
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$RRH_SOFTWARE ## RunesRepoHub 
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$QUICK_INSTALLERS ## Quick Installers
            ;;
        4)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$CRONJOB ## Cronjob
            ;;
        5)
            echo -e "${Green}Updating...${NC}"
            cd $ROOT_FOLDER
            git pull
            echo -e "${Green}You can now run the script fully updated${NC}"
            exit 0
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
    render_welcome_and_menu
    show_menu
    read -p "Enter your choice [1-6]: " choice
    run_script $choice
done