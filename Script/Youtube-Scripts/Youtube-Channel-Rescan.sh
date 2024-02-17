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
output_path=~/plex/media/youtube
media_dir=~/plex/media

# Create or append to a file to keep track of channel URLs
history_file="${output_path}/channel_urls_history.txt"

# Check if there are already 3 youtube-dl Docker containers running
running_containers=$(sudo docker ps --filter ancestor=mikenye/youtube-dl --format '{{.Image}}' | wc -l)
if [ "$running_containers" -ge 1 ]; then
    echo "Maximum number of youtube-dl containers running. Aborting."
    exit 0
fi

# Read a random URL from the history file if there is more than one link
url_count=$(wc -l < "${history_file}")
if [ "$url_count" -gt 1 ]; then
    # Use /usr/bin/shuf to pick a random line number since $RANDOM is not available in crontab
    random_line=$(/usr/bin/shuf -i 1-"$url_count" -n 1)
    url=$(sed -n "${random_line}p" "${history_file}")
else
    url=$(tail -n 1 "${history_file}")
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
