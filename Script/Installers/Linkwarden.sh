#!/bin/bash

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
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

clear 

source ~/RRHQD/Core/Core.sh

if [ ! -d "~/RRHQD-Dockers" ]; then
    mkdir "~/RRHQD-Dockers"
fi

# Clone the Linkwarden repository
dialog --backtitle "Cloning Linkwarden Repository" --infobox "Cloning Linkwarden repository from GitHub..." 5 60
git clone https://github.com/linkwarden/linkwarden.git |& dialog --backtitle "Cloning Linkwarden Repository" --title "Git Clone Output" --textbox - 20 80
cd linkwarden

# Configure Environment Variables interactively using dialog with validation
while true; do
    dialog --backtitle "Environment Variables Configuration" --title "Configure .env File" --inputbox "Enter the NEXTAUTH_SECRET (it should look like '^7yTjn@G$j@KtLh9&@UdMpdfDZ'):" 8 60 2> temp_secret
    NEXTAUTH_SECRET=$(<temp_secret)
    if [[ -z $NEXTAUTH_SECRET ]]; then
        dialog --backtitle "Environment Variables Configuration" --title "Error" --msgbox "NEXTAUTH_SECRET cannot be empty. Please enter a valid value." 6 60
    else
        break
    fi
done
rm temp_secret

while true; do
    dialog --backtitle "Environment Variables Configuration" --title "Configure .env File" --inputbox "Enter the NEXTAUTH_URL (it should look like 'http://localhost:3000/api/v1/auth'):" 8 60 2> temp_url
    NEXTAUTH_URL=$(<temp_url)
    if [[ -z $NEXTAUTH_URL ]]; then
        dialog --backtitle "Environment Variables Configuration" --title "Error" --msgbox "NEXTAUTH_URL cannot be empty. Please enter a valid value." 6 60
    else
        break
    fi
done
rm temp_url

while true; do
    dialog --backtitle "Environment Variables Configuration" --title "Configure .env File" --inputbox "Enter the POSTGRES_PASSWORD:" 8 60 2> temp_password
    POSTGRES_PASSWORD=$(<temp_password)
    if [[ -z $POSTGRES_PASSWORD ]]; then
        dialog --backtitle "Environment Variables Configuration" --title "Error" --msgbox "POSTGRES_PASSWORD cannot be empty. Please enter a valid value." 6 60
    else
        break
    fi
done
rm temp_password



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