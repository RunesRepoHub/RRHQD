#!/bin/bash
# RRHQD/Script/Quick-Installers/Filezilla-Installer.sh

source ~/RRHQD/Core/Core.sh

echo -e "${Green}Starting Filezilla installation on Debian machine...${NC}"

# Update package list
sudo apt update

# Install Filezilla
sudo apt install -y filezilla

echo -e "${Green}Filezilla installation is complete.${NC}"
