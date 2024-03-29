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

echo -e "${Green}Setup a Docker container for Vaultwarden${NC}"

if [ "$decision" == "Y" ] || [ "$decision" == "y" ]; then
    echo -e "${Yellow}Set up instructions: $VAULTWARDEN_HELPLINK${NC}"
elif [ "$decision" == "N" ] || [ "$decision" == "n" ]; then
    echo -e "${Blue}Skipping setup instructions.${NC}"
fi

## Ask user for image
echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter the Docker image for Vaultwarden (e.g., vaultwarden/server:latest): " IMAGE
IMAGE=${IMAGE:-vaultwarden/server:latest}

## Ask user for container name
echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter the name for the Vaultwarden container: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-vaultwarden}

## Ask user for port
echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter the port to expose Vaultwarden on (e.g., 80): " PORT
PORT=${PORT:-80}

## Ask user for path
echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter the path for Vaultwarden data (e.g., /vw-data/): " DATA_PATH
DATA_PATH=${DATA_PATH:-./Data/vw-data}

## Ask user for admin token
echo -e "${Red}This step cannot be skipped${NC}"
read -p "Enter the admin token for Vaultwarden: " ADMIN_TOKEN
# Ensure the user inputs a token
while [ -z "$ADMIN_TOKEN" ]; do
    echo -e "${Red}The admin token cannot be empty. Please enter a valid token.${NC}"
    read -p "Enter the admin token for Vaultwarden: " ADMIN_TOKEN
done

## Ask user for signups allowed or not
echo -e "${Red}This step cannot be skipped${NC}"
read -p "Allow signups? (y/n): " SIGNUPS_ALLOWED
# Ensure the user picks 'y' for yes or 'n' for no
while [[ "$SIGNUPS_ALLOWED" != "y" && "$SIGNUPS_ALLOWED" != "n" ]]; do
    echo -e "${Red}Please pick 'y' for yes or 'n' for no.${NC}"
    read -p "Allow signups? (y/n): " SIGNUPS_ALLOWED
done

## Ask user for enabling WebSockets or not
echo -e "${Red}This step cannot be skipped${NC}"
read -p "Enable WebSockets? (y/n): " WEBSOCKET_ENABLED
# Prompt user for enabling WebSockets with a yes or no answer
while [[ "$WEBSOCKET_ENABLED" != "y" && "$WEBSOCKET_ENABLED" != "n" ]]; do
    echo -e "${Red}Please enter 'y' for yes or 'n' for no.${NC}"
    read -p "Enable WebSockets? (y/n): " WEBSOCKET_ENABLED
done

# Convert y/n input to true/false for environment variables
SIGNUPS_ALLOWED=$( [[ "$SIGNUPS_ALLOWED" == "y" ]] && echo "true" || echo "false" )
WEBSOCKET_ENABLED=$( [[ "$WEBSOCKET_ENABLED" == "y" ]] && echo "true" || echo "false" )

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./RRHQD-Dockers/Vaultwarden"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Create a Docker compose file with the user input inside the subfolder
{
  echo "version: '3'"
  echo "services:"
  echo "  $CONTAINER_NAME:"
  echo "    image: $IMAGE"
  echo "    ports:"
  echo "      - \"$PORT:80\""
  echo "    volumes:"
  echo "      - \"$DATA_PATH:/data\""
  echo "    environment:"
  echo "      - ADMIN_TOKEN=${ADMIN_TOKEN}"
  echo "      - WEBSOCKET_ENABLED=${WEBSOCKET_ENABLED}"
  echo "      - SIGNUPS_ALLOWED=${SIGNUPS_ALLOWED}"
} > "$COMPOSE_FILE"

# Inform the user where the Docker compose file has been created
echo "Docker compose file created at: $COMPOSE_FILE"

# Check if Docker is running and use sudo if the OS is ubuntu, zorin, linuxmint, or kali
OS_DISTRO=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    if ! sudo docker info >/dev/null 2>&1; then
      echo "Docker does not seem to be running, start it first with sudo and then re-run this script."
      exit 1
    fi
    ;;
  *)
    if ! docker info >/dev/null 2>&1; then
      echo "Docker does not seem to be running, start it first and then re-run this script."
      exit 1
    fi
    ;;
esac

# Start the Docker container using docker-compose with or without sudo based on the OS
case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    sudo docker compose -f "$COMPOSE_FILE" up -d
    ;;
  *)
    docker compose -f "$COMPOSE_FILE" up -d
    ;;
esac

# Check if the Docker container(s) have started successfully
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    dialog --title "Success" --msgbox "The Docker container $CONTAINER_NAME has started successfully." 6 60
else
    dialog --title "Error" --msgbox "Failed to start the Docker container $CONTAINER_NAME. Please check the logs for details." 6 60
    exit 1
fi
