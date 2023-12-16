#!/bin/bash
clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

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

echo -e "${Yellow}Update${NC}"
echo -e "${Green}This will update the all scripts used in RRHQD${NC}"
echo

# Display the menu options
function show_menu() {
    echo "Please select an option:"
    echo "1) Find and install a Docker"
    echo "2) Find and install RunesRepoHub Software"
    echo "3) Find and use a Quick Installer for other software"
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
            bash ~/RRHQD/Script/Menu/RRH-Software.sh ## RunesRepoHub 
            ;;
        3)
            bash ~/RRHQD/Script/Menu/Quick-Installers.sh ## Quick Installers
            ;;
        4)
            echo -e "Coming Soon" ## Open Spot
            ;;
        5)
            echo -e "${Green}Updating...${NC}"
            cd ~/RRHQD
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
    show_menu
    read -p "Enter your choice [1-6]: " choice
    run_script $choice
done