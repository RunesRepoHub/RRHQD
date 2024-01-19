# Source Core.sh script if it exists, otherwise exit the script

source ~/RRHQD/Core/Core.sh

if [ -f ~/ACS/ACSF-Scripts/Core.sh ]; then
  source ~/ACS/ACSF-Scripts/Core.sh
else
  dialog --title "Error" --msgbox "Core.sh script not found. Exiting." 6 50
  exit 0
fi

ROOT_FOLDER=~/RRHQD

read -p "Link for youtube playlist: " url

MEDIA="$MEDIA"

output_path="$YOUTUBE"

# Exit if no URL is provided
[ -z "$url" ] && exit

# Extract the video ID from the URL
video_id=$(echo "${url}" | awk -F '[=&]' '{print $2}')
# Get the channel name using youtube-dl --get-filename
channel_name=$(sudo docker run --rm mikenye/youtube-dl --get-filename -o "%(channel)s" "$url" | head -n 1)
# Get the playlist name using youtube-dl --get-filename
playlist_name=$(sudo docker run --rm mikenye/youtube-dl --get-filename -o "%(playlist)s" "$url" | head -n 1)
# If the playlist name is not available, default to 'no_playlist'
playlist_name=${playlist_name:-no_playlist}


# Create the video folder if it doesn't exist
video_folder="${output_path}/${channel_name}/${playlist_name}"
if [ ! -d "${video_folder}" ]; then
    mkdir -p "${video_folder}"
fi
video_file="${video_folder}/${video_id}.mp4"

# Generate a unique container name based on the video ID 
container_name="${video_id}"

# Download video using docker run command in detached mode and delete the container when finished
sudo docker run \
    --rm -d \
    -e PGID=$(id -g) \
    -e PUID=$(id -u) \
    -v "$MEDIA":/workdir:rw \
    -v "$video_folder":/output:rw \
    --name "${container_name}" \
    --cpus 1 \
    --memory 2g \
    mikenye/youtube-dl -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' \
    --write-info-json \
    --write-thumbnail \
    --write-description \
    --write-sub \
    --embed-subs \
    --convert-subs srt \
    --write-auto-sub \
    --download-archive "download-archive.txt" \
    --output '/output/%(title)s.%(ext)s' \
    "${url}"

