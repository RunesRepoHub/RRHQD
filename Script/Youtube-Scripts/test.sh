#!/bin/bash

# Define output path and media directory
output_path=~/plex/media/youtube
media_dir=~/plex/media

# Check if there are already 3 youtube-dl Docker containers running
running_containers=$(sudo docker ps --filter ancestor=mikenye/youtube-dl --format '{{.Image}}' | wc -l)
if [ "$running_containers" -ge 3 ]; then
    echo "Maximum number of youtube-dl containers running. Aborting."
    exit 0
fi

# Define a function to get a random URL from the history file
get_random_url_from_history() {
    local history_file="$1"
    local url_count random_line url

    # Ensure the history file exists and is not empty
    if [ ! -s "${history_file}" ]; then
        echo "History file is missing or empty. Aborting."
        exit 1
    fi

    # Get the count of URLs in the history file
    url_count=$(wc -l < "${history_file}")
    
    # Pick a random line number
    random_line=$((RANDOM % url_count + 1))
    
    # Extract the URL from the random line
    url=$(sed -n "${random_line}p" "${history_file}")
    echo "${url}"
}

# Use the function to get a random URL
url=$(get_random_url_from_history "${history_file}")


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


