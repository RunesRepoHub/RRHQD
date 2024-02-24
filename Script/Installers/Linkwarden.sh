#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/linkwarden_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="linkwarden_install_run_"
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

clear 

source ~/RRHQD/Core/Core.sh

COMPOSE_SUBFOLDER=~/RRHQD-Dockers

if [ ! -d "$COMPOSE_SUBFOLDER" ]; then
    mkdir -p "$COMPOSE_SUBFOLDER"
fi

cd $COMPOSE_SUBFOLDER

# Clone the Linkwarden repository
echo "Cloning Linkwarden repository from GitHub..."
git clone https://github.com/linkwarden/linkwarden.git
cd linkwarden


echo "Do you want to learn more about how to set it up? (Y/N)"
read -p "Enter your choice: " decision

if [ "$decision" == "Y" ] || [ "$decision" == "y" ]; then
    echo "Set up instructions:"
    echo "Follow the setup instructions to configure the system."

    echo "Nextauth secret:"
    echo "NEXTAUTH_SECRET should look like '^7yTjn@G$j@KtLh9&@UdMpdfDZ'"

    echo "Nextauth URL:"
    echo "NEXTAUTH_URL should look like 'http://localhost:3000/api/v1/auth' this can also be a FQDN or IP if FQDN then https:// and no ports"

    echo "Postgres password:"
    echo "POSTGRES_PASSWORD should be set to a strong password"
elif [ "$decision" == "N" ] || [ "$decision" == "n" ]; then
    echo "Skipping setup instructions."
fi

# Configure Environment Variables interactively using dialog
echo "Enter the NEXTAUTH_SECRET (it should look like '^7yTjn@G$j@KtLh9&@UdMpdfDZ'):"
read NEXTAUTH_SECRET

# Check if the NEXTAUTH_SECRET is not empty
if [ -z "$NEXTAUTH_SECRET" ]; then
    echo "NEXTAUTH_SECRET is empty. Please enter a valid secret."
    exit 1
fi

echo "Enter the NEXTAUTH_URL (it should look like 'http://localhost:3000/api/v1/auth'):"
read NEXTAUTH_URL

# Check if the NEXTAUTH_URL is not empty
if [ -z "$NEXTAUTH_URL" ]; then
    echo "NEXTAUTH_URL is empty. Please enter a valid URL."
    exit 1
fi

echo "Enter the POSTGRES_PASSWORD:"
read POSTGRES_PASSWORD

# Check if the POSTGRES_PASSWORD is not empty
if [ -z "$POSTGRES_PASSWORD" ]; then
    echo "POSTGRES_PASSWORD is empty. Please enter a valid password."
    exit 1
fi

# Write the environment variables to .env file
echo "NEXTAUTH_SECRET=$NEXTAUTH_SECRET" > .env
echo "NEXTAUTH_URL=$NEXTAUTH_URL" >> .env
echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> .env

# Run Docker Compose
docker compose up -d

# Check if the Docker container has started successfully
if [ "$(docker ps -q -f ancestor=ghcr.io/linkwarden/linkwarden:latest)" ]; then
    dialog --title "Success" --msgbox "The Docker container ghcr.io/linkwarden/linkwarden:latest has started successfully." 6 60
else
    dialog --title "Error" --msgbox "Failed to start the Docker container ghcr.io/linkwarden/linkwarden:latest. Please check the logs for details." 6 60
    exit 1
fi
