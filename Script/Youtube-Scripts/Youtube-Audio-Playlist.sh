#!/bin/bash

source ~/RRHQD/Core/Core.sh

# Source Core.sh script if it exists, otherwise exit the script
if [ -f ~/ACS/ACSF-Scripts/Core.sh ]; then
  source ~/ACS/ACSF-Scripts/Core.sh
else
  dialog --title "Error" --msgbox "Core.sh script not found. Exiting." 6 50
  exit 0
fi

ROOT_FOLDER=~/RRHQD

# Define output path and media directory
output_path="$YOUTUBE_AUDIO"
media_dir="$MEDIA"

# Read the channel URL
read -p "Enter the YouTube channel URL: " url

# Extract the video ID from the URL
video_id=$(echo "${url}" | awk -F '[=&]' '{print $2}')

# Generate a unique container name based on the video ID 
container_name="${video_id}"


# Check if the URL is provided
if [ -z "$url" ]; then
  echo "No URL provided. Exiting."
  exit 1
fi

# Create or append to a file to keep track of channel URLs
history_file="${output_path}/channel_urls_history.txt"

# Check if output_path exists, if not create it
if [ ! -d "$output_path" ]; then
    mkdir -p "$output_path"
    echo "Created directory: $output_path"
fi

# Ensure the history file exists before attempting to add URLs
if [ ! -f "$history_file" ]; then
    touch "$history_file"
fi

# Add the new channel URL to the history file, ensuring no duplicates
if ! grep -q "^${url}$" "$history_file"; then
    echo "$url" >> "$history_file"
fi

# Run the youtube-dl command in Docker to download the video as mp3
sudo docker run \
    --rm -d \
    -e PGID=$(id -g) \
    -e PUID=$(id -u) \
    -v "${media_dir}":/workdir:rw \
    -v "${output_path}":/output:rw \
    --name "${container_name}" \
    --cpus 1 \
    --memory 2g \
    mikenye/youtube-dl \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --download-archive "download-archive.txt" \
    --output '/output/%(title)s.%(ext)s' \
    --yes-playlist \
    "${url}"

echo "Download completed. The MP3 file is in the directory: $output_dir"
