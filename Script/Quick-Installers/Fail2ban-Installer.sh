#!/bin/bash
# Basic Fail2Ban installation and setup script with user input for configuration

# Update package lists
echo "Updating package lists..."
sudo apt-get update -y

# Install Fail2Ban
echo "Installing Fail2Ban..."
sudo apt-get install fail2ban -y

# Copy the default configuration file to a local configuration file
echo "Creating a basic Fail2Ban configuration..."
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# User input for configuration
read -p "Enter the ban time in seconds (default 600): " ban_time
read -p "Enter the find time in seconds (default 600): " find_time
read -p "Enter the maximum retry attempts (default 5): " max_retry

# Set defaults if no input is provided
ban_time=${ban_time:-600}
find_time=${find_time:-600}
max_retry=${max_retry:-5}

# Update the configuration file with user input
sudo sed -i "s/^bantime  = .*/bantime  = $ban_time/" /etc/fail2ban/jail.local
sudo sed -i "s/^findtime  = .*/findtime  = $find_time/" /etc/fail2ban/jail.local
sudo sed -i "s/^maxretry  = .*/maxretry  = $max_retry/" /etc/fail2ban/jail.local

# Restart Fail2Ban service with new configuration
echo "Restarting Fail2Ban service to apply new settings..."
sudo systemctl restart fail2ban

# Display status to confirm installation and setup
echo "Fail2Ban installation and customized setup completed. Current status:"
sudo fail2ban-client status

# End of script

