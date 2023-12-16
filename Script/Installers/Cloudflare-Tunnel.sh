#!/bin/bash

clear

source ~/RRHQD/Core/Core.sh

echo -e "${Green}Setup a Docker container for Cloudflare Tunnel${NC}"

# Create the appdata directory and set permissions
mkdir -p /mnt/user/appdata/cloudflared/ && chmod -R 777 /mnt/user/appdata/cloudflared/

# Run Cloudflare Tunnel login command
docker run -it --rm -v /mnt/user/appdata/cloudflared:/home/nonroot/.cloudflared/ cloudflare/cloudflared:latest tunnel login

# Prompt user for tunnel name
read -p "Enter the name for the Cloudflare Tunnel: " TUNNELNAME

# Create a Cloudflare tunnel
docker run -it --rm -v /mnt/user/appdata/cloudflared:/home/nonroot/.cloudflared/ cloudflare/cloudflared:latest tunnel create "$TUNNELNAME"

# Create the configuration file
CONFIG_FILE="/mnt/user/appdata/cloudflared/config.yml"
touch "$CONFIG_FILE"

# Prompt user for tunnel UUID
read -p "Enter the Tunnel UUID: " UUID

read -p "Enter if you want to use http or https: " PROTOCOL

# Prompt user for reverse proxy IP
read -p "Enter the reverse proxy IP ($PROTOCOL://): " REVERSEPROXYIP

# Prompt user for the domain
read -p "Enter your domain (yourdomain.com): " YOURDOMAIN

# Populate the configuration file
{
  echo "tunnel: $UUID"
  echo "credentials-file: /home/nonroot/.cloudflared/$UUID.json"
  echo " "
  echo "# forward all traffic to Reverse Proxy w/ SSL"
  echo "ingress:"
  echo "  - service: https://$REVERSEPROXYIP"
  echo "    originRequest:"
  echo "      originServerName: $YOURDOMAIN"
} >> "$CONFIG_FILE"

# Start the Cloudflare tunnel
docker run -it -d --name "Cloudflare Tunnel" -v /mnt/user/appdata/cloudflared:/home/nonroot/.cloudflared/ cloudflare/cloudflared:latest tunnel run -- "$UUID"

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "Docker does not seem to be running, start it first and then re-run this script."
    exit 1
fi
