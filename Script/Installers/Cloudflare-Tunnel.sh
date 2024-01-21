#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/cloudflare_tunnel.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="cloudflare_tunnel_run_"
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

dialog --title "Setup" --msgbox "Setup a Docker container for Cloudflare Tunnel" 5 50

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

# Use dialog to prompt user for tunnel name
TUNNELNAME=$(dialog --title "Cloudflare Tunnel Setup" --inputbox "Enter the name for the Cloudflare Tunnel:" 8 40 3>&1 1>&2 2>&3)

# Create a Cloudflare tunnel
$USE_SUDO docker run -it --rm -v /mnt/user/appdata/cloudflared:/home/nonroot/.cloudflared/ cloudflare/cloudflared:latest tunnel create "$TUNNELNAME"

dialog --title "Configuration Type" --msgbox "Pick what config should be used, for just one site or multiple sites.\\n\\nThis script will only add one website, but just copy its config to the other sites if needed.\\n\\nIf you want to add multiple websites, please edit the config after the script has finished." 10 50

# Use dialog to prompt user for the number of sites to host via the Cloudflare Tunnel
NUM_SITES=$(dialog --title "Cloudflare Tunnel Site Count" --inputbox "Enter the number of sites you want to host via the Cloudflare Tunnel (1 for a single site, more for multiple sites):" 8 60 3>&1 1>&2 2>&3)

# Validate the input to ensure it is a number
while ! [[ "$NUM_SITES" =~ ^[0-9]+$ ]]; do
    dialog --title "Invalid Input" --msgbox "Invalid input. Please enter a valid number." 6 50
NUM_SITES=$(dialog --title "Cloudflare Tunnel Site Count" --inputbox "Enter the number of sites you want to host via the Cloudflare Tunnel:" 8 60 3>&1 1>&2 2>&3)
done

if [ "$NUM_SITES" -eq 1 ]; then
    dialog --title "Configuration Notice" --msgbox "You have selected to host a single site via the Cloudflare Tunnel." 6 60
else
    dialog --title "Configuration Notice" --msgbox "You have selected to host $NUM_SITES sites via the Cloudflare Tunnel." 6 60
fi

# Create the configuration file
CONFIG_FILE="/mnt/user/appdata/cloudflared/config.yml"
$USE_SUDO touch "$CONFIG_FILE"

# Prompt user for tunnel UUID
UUID=$(dialog --title "Cloudflare Tunnel UUID" --inputbox "Enter the Tunnel UUID from above:" 8 50 3>&1 1>&2 2>&3)

# Prompt user for protocol
PROTOCOL=$(dialog --title "Site Protocol" --menu "Choose the protocol your site uses when accessed locally:" 12 50 2 \
  "http" "Use HTTP protocol" \
  "https" "Use HTTPS protocol" 3>&1 1>&2 2>&3)

# Prompt user for reverse proxy IP
REVERSEPROXYIP=$(dialog --title "Reverse Proxy IP" --inputbox "Enter the IP of the machine hosting the website ($PROTOCOL://):" 8 50 3>&1 1>&2 2>&3)

# Prompt user for port
PORT=$(dialog --title "Website Port" --inputbox "Enter the port of the machine hosting the website:" 8 50 3>&1 1>&2 2>&3)

# Prompt user for domain
YOURDOMAIN=$(dialog --title "Domain Name" --inputbox "Enter your domain (e.g., yourdomain.com or website.yourdomain.com):" 8 60 3>&1 1>&2 2>&3)
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

