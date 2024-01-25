#!/bin/bash

source ~/RRHQD/Core/Core.sh

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/n8n_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="n8n_install_run_"
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
# Script to setup and configure a n8n Docker container and start it

# Prompt user for input with defaults
echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter the Docker image for n8n (e.g., n8nio/n8n:latest): " IMAGE
IMAGE=${IMAGE:-"n8nio/n8n:latest"}

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter the name for the n8n container: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"n8n-container"}

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter the port to expose n8n on (e.g., 5678): " PORT
PORT=${PORT:-5678}

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings (Europa/Berlin)${NC}"
read -p "Enter the timezone (e.g., Europe/Berlin): " TZ
TZ=${TZ:-"Europe/Berlin"}

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter the path for n8n data (e.g., /n8n-data/): " DATA_PATH
DATA_PATH=${DATA_PATH:-./Data/n8n-data}

echo -e "${RED}This step cannot be skipped${NC}"
read -p "Enter the subdomain for n8n (e.g., n8n): " SUBDOMAIN

echo -e "${RED}This step cannot be skipped${NC}"
read -p "Enter the domain name (e.g., example.com): " DOMAIN_NAME

echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter a generic timezone for n8n (e.g., UTC): " GENERIC_TIMEZONE
GENERIC_TIMEZONE=${GENERIC_TIMEZONE:-"UTC"}

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./RRHQD-Dockers/n8n-docker"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

chmod 777 -R $COMPOSE_SUBFOLDER/$DATA_PATH

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Create a Docker compose file with the user input
cat > "$COMPOSE_FILE" <<EOF
version: '3'
services:
  $CONTAINER_NAME:
    image: $IMAGE
    environment:
      - TZ=$TZ
      - N8N_HOST=${SUBDOMAIN}.${DOMAIN_NAME}
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - NODE_ENV=production
      - WEBHOOK_URL=https://${SUBDOMAIN}.${DOMAIN_NAME}/
      - GENERIC_TIMEZONE=${GENERIC_TIMEZONE}
    volumes:
      - $DATA_PATH:/home/node/.n8n
    ports:
      - "$PORT:5678"
    restart: always

volumes:
  n8n_data:
    external: true

EOF

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
