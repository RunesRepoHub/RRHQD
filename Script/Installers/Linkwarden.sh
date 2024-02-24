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

source ~/RRHQD/Core/Core.sh
clear

COMPOSE_SUBFOLDER=~/RRHQD-Dockers

if [ ! -d "$COMPOSE_SUBFOLDER" ]; then
    mkdir -p "$COMPOSE_SUBFOLDER"
fi

cd $COMPOSE_SUBFOLDER

if [ -d "linkwarden" ]; then
    echo -e "${Yellow}The folder 'linkwarden' already exists.${NC}"
    echo -e "${Yellow}This can cause issues if the old 'linkwarden' folder is not removed.${NC}"
    read -p "Do you want to remove the old folder first? (Y/N): " remove_decision

    if [ "$remove_decision" == "Y" ] || [ "$remove_decision" == "y" ]; then
        echo "Removing the old 'linkwarden' folder..."
        rm -rf linkwarden
        echo -e "${Blue}Old 'linkwarden' folder removed successfully.${NC}"
    else
        echo -e "${Yellow}Skipping removal of the old 'linkwarden' folder.${NC}"
        echo -e "${Yellow}This can cause issues if the old 'linkwarden' folder is not removed.${NC}"
    fi
fi

# Clone the Linkwarden repository
echo -e "${Yellow}Cloning Linkwarden repository from GitHub...${NC}"
git clone https://github.com/linkwarden/linkwarden.git
cd linkwarden


echo -e "${Yellow}Do you want to learn more about how to set it up? (Y/N)${NC}"
read -p "Enter your choice: " decision

if [ "$decision" == "Y" ] || [ "$decision" == "y" ]; then
    echo -e "${Yellow}Set up instructions:${NC}"
    echo -e "${Yellow}Follow the setup these instructions to configure the system.${NC}"

    echo -e "${Yellow}Nextauth secret:${NC}"
    echo -e "${Blue}NEXTAUTH_SECRET should look like ^7yTjn@G$j@KtLh9&@UdMpdfDZ${NC}"

    echo -e "${Yellow}Nextauth URL:${NC}"
    echo -e "${Blue}NEXTAUTH_URL should look like 'http://localhost:3000/api/v1/auth' this can also be a FQDN or IP if FQDN then https:// and no ports${NC}"

    echo -e "${Yellow}Postgres password:${NC}"
    echo -e "${Blue}POSTGRES_PASSWORD should be set to a strong password${NC}"
elif [ "$decision" == "N" ] || [ "$decision" == "n" ]; then
    echo -e "${Blue}Skipping setup instructions.${NC}"
fi

echo 
echo
echo -e "${Blue}-------------------------------------${NC}"
echo -e "${Blue}--------${NC}${Green}Setting up Linkwarden${NC}${Blue}--------${NC}"
echo -e "${Blue}-------------------------------------${NC}"

# Configure Environment Variables interactively using dialog
echo -e "${Yellow}Enter the NEXTAUTH_SECRET (it should look like ^7yTjn@G$j@KtLh9&@UdMpdfDZ):${NC}"
read NEXTAUTH_SECRET

# Check if the NEXTAUTH_SECRET is not empty
if [ -z "$NEXTAUTH_SECRET" ]; then
    echo -e "${Red}NEXTAUTH_SECRET is empty. Please enter a valid secret.${NC}"
    exit 1
fi

echo -e "${Yellow}Enter the NEXTAUTH_URL (it should look like 'http://localhost:3000/api/v1/auth'):${NC}"
read NEXTAUTH_URL

# Check if the NEXTAUTH_URL is not empty
if [ -z "$NEXTAUTH_URL" ]; then
    echo -e "${Red}NEXTAUTH_URL is empty. Please enter a valid URL.${NC}"
    exit 1
fi

echo -e "${Yellow}Enter the POSTGRES_PASSWORD:${NC}"
read POSTGRES_PASSWORD

# Check if the POSTGRES_PASSWORD is not empty
if [ -z "$POSTGRES_PASSWORD" ]; then
    echo -e "${Red}POSTGRES_PASSWORD is empty. Please enter a valid password.${NC}"
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
