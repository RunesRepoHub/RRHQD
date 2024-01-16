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

# Check if the current script is already scheduled in /etc/crontab
script_path=$ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_SCRIPTS_FOLDER/$YOUTUBE_CHANNEL_AUTO
script_entry="0 1 * * * root $script_path"

if grep -qF -- "$script_entry" /etc/crontab; then
  echo "Script $script_path is already scheduled to run daily at 01:00 AM."
else
  # Schedule the script to run daily at 01:00 AM
  echo "$script_entry" >> /etc/crontab
  echo "Script $script_path scheduled to run daily at 01:00 AM successfully."
fi


# Define output path and media directory
output_path="$YOUTUBE"
media_dir="$MEDIA"

# Create or append to a file to keep track of channel URLs
history_file="${output_path}/channel_urls_history.txt"

# Read a random URL from the history file if there is more than one link
url_count=$(wc -l < "${history_file}")
if [ "$url_count" -gt 1 ]; then
    # Pick a random line number
    random_line=$((RANDOM % url_count + 1))
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
    --download-archive "download-archive.txt" \
    --output '/output/%(title)s.%(ext)s' \
    --yes-playlist \
    "${url}"

dialog --title "Download Started" --msgbox "Download started for the channel: ${channel_name}\nVideos will be saved in the folder: ${channel_folder}" 8 50

