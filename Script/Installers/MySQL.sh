#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/mysql_install.log"
increment_log_file_name() {
  local log_file_base_name="mysql_install_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file will be saved as $LOG_FILE"
}

mkdir -p "$LOG_DIR"
increment_log_file_name
exec > >(tee -a "$LOG_FILE") 2>&1

cd
echo "MySQL Docker configuration script."

# Define default values
DEFAULT_IMAGE="mysql:5.7"
DEFAULT_CONTAINER_NAME="mysql-container"
DEFAULT_PORT=3306
DEFAULT_DB_USER="root"
DEFAULT_DB_PASS="mysql"
DEFAULT_DB_NAME="mydb"

# Use dialog to ask for user input
IMAGE=$(dialog --title "MySQL Docker Configuration" --inputbox "Enter the Docker image for MySQL (e.g., mysql:5.7):" 8 50 "$DEFAULT_IMAGE" 3>&1 1>&2 2>&3 3>&-)
CONTAINER_NAME=$(dialog --title "MySQL Docker Configuration" --inputbox "Enter the name for the MySQL container:" 8 50 "$DEFAULT_CONTAINER_NAME" 3>&1 1>&2 2>&3 3>&-)
PORT=$(dialog --title "MySQL Docker Configuration" --inputbox "Enter the port to expose MySQL on (e.g., 3306):" 8 50 "$DEFAULT_PORT" 3>&1 1>&2 2>&3 3>&-)
DB_USER=$(dialog --title "MySQL Docker Configuration" --inputbox "Enter the database user:" 8 50 "$DEFAULT_DB_USER" 3>&1 1>&2 2>&3 3>&-)
DB_PASS=$(dialog --title "MySQL Docker Configuration" --inputbox "Enter the database password:" 8 50 "$DEFAULT_DB_PASS" 3>&1 1>&2 2>&3 3>&-)
DB_NAME=$(dialog --title "MySQL Docker Configuration" --inputbox "Enter the default database name:" 8 50 "$DEFAULT_DB_NAME" 3>&1 1>&2 2>&3 3>&-)

COMPOSE_SUBFOLDER="./RRHQD-Dockers/mysql-docker"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"
mkdir -p "$COMPOSE_SUBFOLDER"

cat > "$COMPOSE_FILE" <<EOF
version: '3'
services:
  $CONTAINER_NAME:
    image: $IMAGE
    container_name: $CONTAINER_NAME
    environment:
      - MYSQL_DATABASE=$DB_NAME
      - MYSQL_USER=$DB_USER
      - MYSQL_PASSWORD=$DB_PASS
      - MYSQL_ROOT_PASSWORD=$DB_PASS
    volumes:
      - ./mysql-data:/var/lib/mysql
    ports:
      - "$PORT:3306"
    restart: always
EOF

dialog --title "Success" --msgbox "Docker compose file created at: $COMPOSE_FILE" 6 50

OS_DISTRO=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')

if [[ "ubuntu zorin linuxmint kali" =~ $OS_DISTRO ]]; then
  if ! sudo docker info >/dev/null 2>&1; then
    dialog --title "Docker Not Running" --msgbox "Docker does not seem to be running, start it first with sudo and then re-run this script." 6 50
    exit 1
  fi
  sudo docker compose -f "$COMPOSE_FILE" up -d
else
  if ! docker info >/dev/null 2>&1; then
    dialog --title "Docker Not Running" --msgbox "Docker does not seem to be running, start it first and then re-run this script." 6 50
    exit 1
  fi
  docker compose -f "$COMPOSE_FILE" up -d
fi

# Check if the Docker container(s) have started successfully
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    dialog --title "Success" --msgbox "The Docker container $CONTAINER_NAME has started successfully." 6 60
else
    dialog --title "Error" --msgbox "Failed to start the Docker container $CONTAINER_NAME. Please check the logs for details." 6 60
    exit 1
fi