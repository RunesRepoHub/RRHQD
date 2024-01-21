#!/bin/bash

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/ntfy_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="ntfy_install_run_"
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
# Script to configure and start a Docker container running NTFY

# Use dialog to prompt user for input with defaults in a more user-friendly way

# Define dialog exit status codes
: "${DIALOG_OK=0}"
: "${DIALOG_CANCEL=1}"
: "${DIALOG_ESC=255}"

# Function to prompt user input using dialog
prompt_with_dialog() {
  local __resultvar=$1
  local __title=$2
  local __prompt=$3
  local __default=$4
  local __input=""

  dialog --title "$__title" --inputbox "$__prompt" 8 60 "$__default" 2> /tmp/input.$$
  
  local exit_status=$?
  case $exit_status in
    $DIALOG_OK)
      __input=$(< /tmp/input.$$)
      ;;
    $DIALOG_CANCEL)
      echo "Cancel pressed."
      ;;
    $DIALOG_ESC)
      echo "ESC pressed."
      ;;
  esac
  rm -f /tmp/input.$$

  # If input is empty, use default value
  if [[ -z "$__input" ]]; then
    eval $__resultvar="'$__default'"
  else
    eval $__resultvar="'$__input'"
  fi
}

# Prompt user for Docker image with dialog
prompt_with_dialog IMAGE "NTFY Docker Configuration" "Enter the Docker image for NTFY (e.g., binwiederhier/ntfy:latest):" "binwiederhier/ntfy:latest"

# Prompt user for container name with dialog
prompt_with_dialog CONTAINER_NAME "NTFY Docker Configuration" "Enter the name for the NTFY container:" "ntfy-container"

# Prompt user for port with dialog
prompt_with_dialog PORT "NTFY Docker Configuration" "Enter the port to expose NTFY on (e.g., 8080):" "8080"

# Prompt user for data path with dialog
prompt_with_dialog DATA_PATH "NTFY Docker Configuration" "Enter the path for NTFY data (e.g., /ntfy-data/):" "./Data/ntfy-data"

# Define the subfolder for the Docker compose files
COMPOSE_SUBFOLDER="./ntfy-docker"
COMPOSE_FILE="$COMPOSE_SUBFOLDER/docker-compose-$CONTAINER_NAME.yml"

# Create the subfolder if it does not exist
mkdir -p "$COMPOSE_SUBFOLDER"

# Create a Docker compose file with the user input
{
echo "version: '3'"
echo "services:"
echo "  $CONTAINER_NAME:"
echo "    image: $IMAGE"
echo "    container_name: $CONTAINER_NAME"
echo "    command:"
echo "      - serve"
echo "    environment:"
echo "      - TZ=UTC"
echo "    volumes:"
echo "      - $DATA_PATH:/var/cache/ntfy"
echo "      - /etc/ntfy:/etc/ntfy"
echo "    ports:"
echo "      - \"$PORT:80\""
echo "    restart: always"
} > "$COMPOSE_FILE"

# Inform the user where the Docker compose file has been created using dialog
dialog --title "File Created" --msgbox "Docker compose file created at: $COMPOSE_FILE" 6 50

# Check if Docker is running and use sudo if the OS is ubuntu, zorin, linuxmint, or kali
OS_DISTRO=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
case $OS_DISTRO in
  ubuntu|zorin|linuxmint|kali)
    if ! sudo docker info >/dev/null 2>&1; then
      dialog --title "Docker not running" --msgbox "Docker does not seem to be running. Please start it first with sudo and then re-run this script." 10 60
      exit 1
    fi
    ;;
  *)
    if ! docker info >/dev/null 2>&1; then
      dialog --title "Docker not running" --msgbox "Docker does not seem to be running. Please start it first and then re-run this script." 10 60
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

# Inform the user that the script has finished
dialog --title "NTFY Installed" --msgbox "NTFY has been installed successfully." 6 50