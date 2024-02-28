#!/bin/bash

# Ask user to input a password
read -s -p "Enter the MySQL password: " PASSWORD

# Install MariaDB Server
sudo apt install mariadb-server

# Start MariaDB service
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl status mariadb

# Secure MariaDB installation
sudo mysql_secure_installation

# Log in to MariaDB
sudo mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS pydiodb;
CREATE USER IF NOT EXISTS 'pydiouser'@'localhost' IDENTIFIED BY '$PASSWORD';
GRANT ALL PRIVILEGES ON pydiodb.* to 'pydiouser'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT


# Set the distribution ID to 'cells'
distribId=cells

# Download the Pydio Cells binary and save it to /usr/bin/cells
wget -O /usr/bin/cells https://download.pydio.com/latest/${distribId}/release/{latest}/linux-amd64/${distribId}

# Make the downloaded file executable
sudo chmod +x /usr/bin/cells

# Set capabilities for the cells binary to bind to privileged ports
sudo setcap 'cap_net_bind_service=+ep' /usr/bin/cells

# Run the Pydio Cells configuration
cells configure
