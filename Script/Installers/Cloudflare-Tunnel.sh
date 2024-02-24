#!/bin/bash

SCRIPT_FILENAME=$(basename "$0")

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/"$SCRIPT_FILENAME"_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name=""$SCRIPT_FILENAME"_install_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file will be saved as $LOG_FILE"
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

cd

clear

source ~/RRHQD/Core/Core.sh

echo -e "${Green}Setup a Docker container for Cloudflare Tunnel${NC}"

# Detect OS and set USE_SUDO accordingly
OS_NAME=$(grep '^ID=' /etc/os-release | cut -d= -f2)
USE_SUDO=""
if [[ "$OS_NAME" == "ubuntu" || "$OS_NAME" == "kali" || "$OS_NAME" == "linuxmint" || "$OS_NAME" == "zorin" ]]; then
  USE_SUDO="sudo"
fi

# Create the appdata directory and set permissions
$USE_SUDO mkdir -p /mnt/user/appdata/cloudflared/ && $USE_SUDO chmod -R 777 /mnt/user/appdata/cloudflared/

# Run Cloudflare Tunnel login command
$USE_SUDO docker run -it --rm -v /mnt/user/appdata/cloudflared:/home/nonroot/.cloudflared/ cloudflare/cloudflared:latest tunnel login

# Prompt user for tunnel name
read -p "Enter the name for the Cloudflare Tunnel: " TUNNELNAME

# Create a Cloudflare tunnel
$USE_SUDO docker run -it --rm -v /mnt/user/appdata/cloudflared:/home/nonroot/.cloudflared/ cloudflare/cloudflared:latest tunnel create "$TUNNELNAME"

echo -e "${Green}Pick what config should be used, for just one site or multiple sites${NC}"
echo -e "${Yellow}This script will only add one website, but just copi its config to the other sites if needed${NC}"
echo -e "${Yellow}If you want to add multiple websites, please use edit the config after the script has finished${NC}"

# Prompt user for the number of sites to host via the Cloudflare Tunnel
read -p "Enter the number of sites you want to host via the Cloudflare Tunnel (1 for a single site, more for multiple sites): " NUM_SITES

# Validate the input to ensure it is a number
while ! [[ "$NUM_SITES" =~ ^[0-9]+$ ]]; do
    echo "Invalid input. Please enter a valid number."
    read -p "Enter the number of sites you want to host via the Cloudflare Tunnel: " NUM_SITES
done

if [ "$NUM_SITES" -eq 1 ]; then
    echo "You have selected to host a single site via the Cloudflare Tunnel."
else
    echo "You have selected to host $NUM_SITES sites via the Cloudflare Tunnel."
fi

# Create the configuration file
CONFIG_FILE="/mnt/user/appdata/cloudflared/config.yml"
$USE_SUDO touch "$CONFIG_FILE"

# Prompt user for tunnel UUID
echo -e "${Yellow}Enter the Tunnel UUID from above${NC}"

read -p "Enter the Tunnel UUID: " UUID

echo -e "${Yellow}What does the site use when accessing it locally?${NC}"

read -p "Enter if you want to use http or https: " PROTOCOL

echo -e "${Yellow}Enter the IP of the machine hosting the website${NC}"
# Prompt user for reverse proxy IP
read -p "Enter the reverse proxy IP ($PROTOCOL://): " REVERSEPROXYIP

echo -e "${Yellow}Enter the port of the machine hosting the website${NC}"
# Prompt user for the port
read -p "Enter the port: " PORT

echo -e "${Yellow}Enter your domain (yourdomain.com or website.yourdomain.com)${NC}"
# Prompt user for the domain
read -p "Enter your domain (yourdomain.com): " YOURDOMAIN
if [ "$NUM_SITES" -eq 1 ]; then
  # Populate the configuration file
  {
    echo "tunnel: $UUID"
    echo "credentials-file: /home/nonroot/.cloudflared/$UUID.json"
    echo " "
    echo "# forward all traffic to Reverse Proxy w/ SSL"
    echo "ingress:"
    echo "  - service: $PROTOCOL://$REVERSEPROXYIP:$PORT"
    echo "    originRequest:"
    echo "      originServerName: $YOURDOMAIN"
  } >> $USE_SUDO "$CONFIG_FILE"
else 
  # Populate the configuration file
  {
    echo "tunnel: $UUID"
    echo "credentials-file: /home/nonroot/.cloudflared/$UUID.json"
    echo " "
    echo "# forward all traffic to Reverse Proxy w/ SSL"
    echo "# NOTE: You should only have one ingress tag, so if you uncomment one block, comment the other one."
    echo "ingress:"
    echo "  - hostname: $YOURDOMAIN"
    echo "    service: $PROTOCOL://$REVERSEPROXYIP:$PORT"
    echo "  - service: http_status:404"
  } >>$USE_SUDO "$CONFIG_FILE"

  dialog --title "Configuration Complete" --msgbox "\nConfiguration file created at: $CONFIG_FILE\n\nConfigure the file for the other sites manually, and then restart the Cloudflare tunnel Docker.\nYou can copy hostname and service from the above site configuration, and just update the information in the configuration file." 10 50
fi

# Start the Cloudflare tunnel
$USE_SUDO docker run -it -d --name "cloudflare-tunnel" -v /mnt/user/appdata/cloudflared:/home/nonroot/.cloudflared/ cloudflare/cloudflared:latest tunnel run -- "$UUID"

