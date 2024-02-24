#!/bin/bash

# Clone the Linkwarden repository
cd ~/RRHQD-Dockers
# Clone the Linkwarden repository
dialog --backtitle "Cloning Linkwarden Repository" --infobox "Cloning Linkwarden repository from GitHub..." 5 60
git clone https://github.com/linkwarden/linkwarden.git |& dialog --backtitle "Cloning Linkwarden Repository" --title "Git Clone Output" --textbox - 20 80
cd linkwarden

# Configure Environment Variables interactively using dialog
dialog --backtitle "Environment Variables Configuration" --title "Configure .env File" --inputbox "Enter the NEXTAUTH_SECRET (it should look like '^7yTjn@G$j@KtLh9&@UdMpdfDZ'): " 8 60 2> temp_secret
NEXTAUTH_SECRET=$(<temp_secret)
rm temp_secret

dialog --backtitle "Environment Variables Configuration" --title "Configure .env File" --inputbox "Enter the NEXTAUTH_URL (it should look like 'http://localhost:3000/api/v1/auth'):" 8 60 2> temp_url
NEXTAUTH_URL=$(<temp_url)
rm temp_url

dialog --backtitle "Environment Variables Configuration" --title "Configure .env File" --inputbox "Enter the POSTGRES_PASSWORD:" 8 60 2> temp_password
POSTGRES_PASSWORD=$(<temp_password)
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
