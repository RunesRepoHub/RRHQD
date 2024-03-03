#!/bin/bash

source ~/RRHQD/Core/Core.sh

# Ask user to input a password
echo -e "${Blue}Input a password for the MySQL user 'pydiouser'${NC}"
read -s -p "Enter the MySQL password: " PASSWORD

# Install MariaDB Server
echo -e "${Blue}Installing MariaDB Server${NC}"
sudo apt install mariadb-server -y
echo -e "${Green}MariaDB Server installed successfully${NC}"

# Start MariaDB service
echo -e "${Blue}Starting MariaDB service${NC}"
sudo systemctl start mariadb
sudo systemctl enable mariadb
echo -e "${Green}MariaDB service started successfully${NC}"

# Secure MariaDB installation
echo -e "${Blue}Securing MariaDB installation${NC}"
sudo mysql_secure_installation
echo -e "${Green}MariaDB installation secured successfully${NC}"

# Log in to MariaDB
echo -e "${Blue}Log in to MariaDB and configure user access${NC}"
sudo mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS pydiodb;
CREATE USER IF NOT EXISTS 'pydiouser'@'localhost' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON pydiodb.* to 'pydiouser'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
echo -e "${Green}User access configured successfully${NC}"


# Install Pydio Cells
echo -e "${Blue}Downloading Pydio Cells${NC}"
# Set the distribution ID to 'cells'
distribId=cells
# Download the Pydio Cells binary and save it to /usr/bin/cells
wget -O /usr/bin/cells https://download.pydio.com/latest/${distribId}/release/{latest}/linux-amd64/${distribId}

echo -e "${Blue}Configure Pydio Cells${NC}"
# Make the downloaded file executable
sudo chmod +x /usr/bin/cells
# Set capabilities for the cells binary to bind to privileged ports
sudo setcap 'cap_net_bind_service=+ep' /usr/bin/cells
# Run the Pydio Cells configuration
cells configure
echo -e "${Green}Pydio Cells installed successfully${NC}"