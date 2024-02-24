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

# Ask user for necessary environment variables
echo -e "${Green}Setting up Ghost Docker container.${NC}"

## Ask user for image
echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter Docker image for Ghost (e.g., ghost:latest): " IMAGE
IMAGE=${IMAGE:-"ghost:latest"}

## Ask user for container name
echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter container name: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"ghost_blog"}

## Ask user for URL
echo -e "${Yellow}This step can't be skipped${NC}"
echo -e "${Blue}You can test Ghost locally by using domain: (http://ip-address:2368)${NC}"
read -p "Enter URL for Ghost (https://blog.yourdomain.com): " URL

# Ensure the user inputs a URL
if [ -z "$URL" ]; then
    echo -e "${Red}You must enter a URL for Ghost.${NC}"
    while [ -z "$URL" ]; do
        read -p "Enter URL for Ghost: " URL
    done
fi

## Ask user for port
echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter port for Ghost: " PORTS
PORTS=${PORTS:-2368}

## Ask user for Ghost content folder
echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter Ghost content folder: " GHOST_CONTENT_FOLDER
GHOST_CONTENT_FOLDER=${GHOST_CONTENT_FOLDER:-./ghost/content}

## Ask user for MySQL password
echo -e "${Yellow}This step can't be skipped${NC}"
read -s -p "Enter MySQL password: " MYSQL_PASSWORD

## Ask user for MySQL Root password
echo -e "${Yellow}This step can't be skipped${NC}"
read -s -p "Enter MySQL root password: " MYSQL_ROOT_PASSWORD

## Ask user for MySQL folder
echo -e "${Green}This step can be skipped if you don't want any changes to the default settings${NC}"
read -p "Enter MySQL folder: " MYSQL_FOLDER
MYSQL_FOLDER=${MYSQL_FOLDER:-./ghost/mysql}

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./RRHQD-Dockers/Ghost"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Create a Docker Compose file for Ghost
cat > $COMPOSE_FILE <<EOF
version: "3.3"
services:
  $CONTAINER_NAME:
    image: $IMAGE
    restart: always
    ports:
      - "$PORTS:2368"
    depends_on:
      - db
    environment:
      url: $URL
      database__client: mysql
      database__connection__host: db
      database__connection__user: ghost
      database__connection__password: $MYSQL_PASSWORD
      database__connection__database: ghostdb
    volumes:
      - $GHOST_CONTENT_FOLDER:/var/lib/ghost/content

  db:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: 9iVCtC&heeW2w!%HEkmzL*KBdN
      MYSQL_USER: ghost
      MYSQL_PASSWORD: $MYSQL_PASSWORD
      MYSQL_DATABASE: ghostdb
    volumes:
      - $MYSQL_FOLDER:/var/lib/mysql
EOF

# Inform the user that the Docker Compose file has been created
echo "Docker Compose file for Ghost has been created."

# Run Docker Compose to start the container
echo "Starting Ghost container..."
docker compose -f $COMPOSE_FILE up -d

# Check if the Docker container(s) have started successfully
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    dialog --title "Success" --msgbox "The Docker container $CONTAINER_NAME has started successfully." 6 60
else
    dialog --title "Error" --msgbox "Failed to start the Docker container $CONTAINER_NAME. Please check the logs for details." 6 60
    exit 1
fi
