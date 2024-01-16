#!/bin/bash

# Source Core.sh script if it exists, otherwise exit the script
if [ -f ~/ACS/ACSF-Scripts/Core.sh ]; then
  source ~/ACS/ACSF-Scripts/Core.sh
else
  dialog --title "Error" --msgbox "Core.sh script not found. Exiting." 6 50
  exit 0
fi

read -p "Enter the YouTube playlist URL: " url

# Exit if no URL is provided
if [ -z "$url" ]; then
  echo "No URL provided. Exiting."
  exit 1
fi

# Detect OS and set USE_SUDO accordingly
OS_NAME=$(grep '^ID=' /etc/os-release | cut -d= -f2)
USE_SUDO=""
if [[ "$OS_NAME" == "ubuntu" || "$OS_NAME" == "kali" || "$OS_NAME" == "linuxmint" || "$OS_NAME" == "zorin" ]]; then
  USE_SUDO="sudo"
fi

download_playlist() {
  local url=$1
  local playlist_name=$($USE_SUDO docker run --rm mikenye/youtube-dl --get-filename -o "%(playlist)s" "$url" | head -n 1)
  playlist_name=${playlist_name:-no_playlist}

  local output_path="$YOUTUBE_AUDIO/$playlist_name"
  mkdir -p "${output_path}"

  $USE_SUDO docker run \
      --rm \
      -e PGID=$(id -g) \
      -e PUID=$(id -u) \
      -v "$MEDIA":/workdir:rw \
      -v "$output_path":/output:rw \
      mikenye/youtube-dl \
      -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' \
      --yes-playlist \
      --write-info-json \
      --write-thumbnail \
      --write-description \
      --write-sub \
      --embed-subs \
      --convert-subs srt \
      --write-auto-sub \
      --download-archive "download-archive.txt" \
      --output "/output/%(title)s.%(ext)s" \
      "$url"
}

download_playlist "$url"

