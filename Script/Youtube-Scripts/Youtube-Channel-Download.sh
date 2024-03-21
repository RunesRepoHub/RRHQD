#!/bin/bash

source ~/RRHQD/Core/Core.sh

# Source Core.sh script if it exists, otherwise exit the script
if [ -f ~/RRHQD/Core/ACS-Core.sh ]; then
  source ~/RRHQD/Core/ACS-Core.sh
else
  dialog --title "Error" --msgbox "Core.sh script not found. Exiting." 6 50
  exit 0
fi

ROOT_FOLDER=~/RRHQD

# Define output path and media directory
output_path="$YOUTUBE"
media_dir="$MEDIA"

# Read the channel URL
read -p "Enter the YouTube channel URL: " url

# Check if the URL is provided
if [ -z "$url" ]; then
  dialog --title "Error" --msgbox "No URL provided. Exiting." 6 50
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
sudo docker run \
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
