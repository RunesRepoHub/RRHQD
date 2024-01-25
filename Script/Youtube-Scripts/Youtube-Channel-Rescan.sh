#!/bin/bash

source ~/RRHQD/Core/Core.sh

# Source Core.sh script if it exists, otherwise exit the script
if [ -f ~/ACS/ACSF-Scripts/Core.sh ]; then
  source ~/ACS/ACSF-Scripts/Core.sh
else
  dialog --title "Error" --msgbox "ACS Core.sh script not found. Exiting." 6 50
  exit 0
fi


# Define output path and media directory
output_path="$YOUTUBE"
media_dir="$MEDIA"

# Create or append to a file to keep track of channel URLs
history_file="${output_path}/channel_urls_history.txt"

# Check if there are already 3 youtube-dl Docker containers running
running_containers=$(sudo docker ps --filter ancestor=mikenye/youtube-dl --format '{{.Image}}' | wc -l)
if [ "$running_containers" -ge 3 ]; then
    echo "Maximum number of youtube-dl containers running. Aborting."
    exit 0
fi

# Determine the line number of the last processed URL
last_processed_line_file="${output_path}/.last_processed_line"
if [ -f "${last_processed_line_file}" ]; then
    last_processed_line=$(<"${last_processed_line_file}")
else
    last_processed_line=0
fi

# Get the total number of URLs in the history file
url_count=$(wc -l < "${history_file}")

# If all URLs have been processed, start over
if [ "$last_processed_line" -ge "$url_count" ]; then
    last_processed_line=0
fi

# Calculate the line number of the next URL to process
next_line=$((last_processed_line + 1))

# Read the next URL from the history file
url=$(sed -n "${next_line}p" "${history_file}")

link=$url
channel_name="${link##*@}"

# Update the last processed line number
echo "${next_line}" > "${last_processed_line_file}"

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
