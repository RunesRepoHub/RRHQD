#!/bin/bash

# Source Core.sh script if it exists, otherwise exit the script
if [ -f ~/ACS/ACSF-Scripts/Core.sh ]; then
  source ~/ACS/ACSF-Scripts/Core.sh
else
  dialog --title "Error" --msgbox "Core.sh script not found. Exiting." 6 50
  exit 0
fi

# Define output path and media directory
output_path="$YOUTUBE"
media_dir="$MEDIA"

# Read the channel URL
read -p "Enter the YouTube channel URL: " url

# Check if the URL is provided
if [ -z "$url" ]; then
  echo "No URL provided. Exiting."
  exit 1
fi


# Ensure the history file exists before attempting to add URLs
if [ ! -f "$history_file" ]; then
    touch "$history_file"
fi

# Create or append to a file to keep track of channel URLs
history_file="${output_path}/channel_urls_history.txt"

# Add the new channel URL to the history file, ensuring no duplicates
if ! grep -q "^${url}$" "$history_file"; then
    echo "$url" >> "$history_file"
fi

# Get the channel name using youtube-dl --get-filename
channel_name=$(docker run --rm mikenye/youtube-dl --get-filename -o "%(uploader)s" "$url" | head -n 1)

# If the channel name is not available, default to 'unknown_channel'
channel_name=${channel_name:-unknown_channel}

# Create the channel folder if it doesn't exist
channel_folder="${output_path}/${channel_name}"
if [ ! -d "${channel_folder}" ]; then
    mkdir -p "${channel_folder}"
fi

# Generate a unique container name based on the channel name
container_name="youtube_dl_${channel_name}"

# Download all videos from the channel using youtube-dl in a Docker container
docker run \
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
    --download-archive "${channel_folder}/download-archive.txt" \
    --output '/output/%(title)s.%(ext)s' \
    --yes-playlist \
    "${url}"

dialog --title "Download Started" --msgbox "Download started for the channel: ${channel_name}\nVideos will be saved in the folder: ${channel_folder}" 8 50
