#!/bin/bash

# Source Core.sh script if it exists, otherwise exit the script
if [ -f ~/ACS/ACSF-Scripts/Core.sh ]; then
  source ~/ACS/ACSF-Scripts/Core.sh
else
  dialog --title "Error" --msgbox "Core.sh script not found. Exiting." 6 50
  exit 0
fi

ROOT_FOLDER=~/RRHQD

# Define output path and media directory
output_path="$YOUTUBE"
media_dir="$MEDIA"

# Detect OS and set USE_SUDO accordingly
OS_NAME=$(grep '^ID=' /etc/os-release | cut -d= -f2)
USE_SUDO=""
if [[ "$OS_NAME" == "ubuntu" || "$OS_NAME" == "kali" || "$OS_NAME" == "linuxmint" || "$OS_NAME" == "zorin" ]]; then
  USE_SUDO="sudo"
fi

# Read the channel URL
read -p "Enter the YouTube channel URL: " url

# Check if the URL is provided
if [ -z "$url" ]; then
  echo "No URL provided. Exiting."
  exit 1
fi

# Create or append to a file to keep track of channel URLs
history_file="${output_path}/channel_urls_history.txt"

# Ensure the history file exists before attempting to add URLs
if [ ! -f "$history_file" ]; then
    touch "$history_file"
fi

# Add the new channel URL to the history file, ensuring no duplicates
if ! grep -q "^${url}$" "$history_file"; then
    echo "$url" >> "$history_file"
fi

link=$url
channel_name="${link##*@}"

# Create the channel folder if it doesn't exist
channel_folder="${output_path}/${channel_name}"
if [ ! -d "${channel_folder}" ]; then
    mkdir -p "${channel_folder}"
fi

# Generate a unique container name based on the channel name
container_name="youtube_dl_${channel_name}"

# Download all videos from the channel using youtube-dl in a Docker container
$USE_SUDO docker run \
    --rm -d \
    -e PGID=$(id -g) \
    -e PUID=$(id -u) \
    -v "${media_dir}":/workdir:rw \
    -v "${channel_folder}":/output:rw \
    --name "${container_name}" \
    --cpus 1 \
    --memory 2g \
    mikenye/youtube-dl \
    -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' \
    --write-info-json \
    --write-thumbnail \
    --write-description \
    --write-sub \
    --embed-subs \
    --convert-subs srt \
    --write-auto-sub \
    --download-archive "download-archive.txt" \
    --output '/output/%(title)s.%(ext)s' \
    --yes-playlist \
    "${url}"

dialog --title "Download Started" --msgbox "Download started for the channel: ${channel_name}\nVideos will be saved in the folder: ${channel_folder}" 8 50
