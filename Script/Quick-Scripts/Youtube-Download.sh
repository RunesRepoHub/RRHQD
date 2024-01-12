# Create a sanitized folder name by replacing invalid characters
sanitize_folder() {
  echo "$1" | sed 's/[^a-zA-Z0-9_.-]/_/g'
}

# Prompt user to enter the desired output path for the downloaded video
read -p "Enter the output path for the downloaded video: " output_path
read -p "Link for youtube playlist: " url

MEDIA=~/plex/media

# Exit if no URL is provided
[ -z "$url" ] && exit

# Extract the video ID from the URL
video_id=$(echo "${url}" | awk -F '[=&]' '{print $2}')
# Get the channel name using youtube-dl --get-filename
channel_name=$(docker run --rm mikenye/youtube-dl --get-filename -o "%(channel)s" "$url" | head -n 1)
# Get the playlist name using youtube-dl --get-filename
playlist_name=$(docker run --rm mikenye/youtube-dl --get-filename -o "%(playlist)s" "$url" | head -n 1)
# If the playlist name is not available, default to 'no_playlist'
playlist_name=${playlist_name:-no_playlist}

# Sanitize channel and playlist names to ensure they do not contain invalid characters
sanitized_channel_name=$(sanitize_folder "${channel_name}")
sanitized_playlist_name=$(sanitize_folder "${playlist_name}")

# Create the video folder if it doesn't exist
video_folder="${output_path}/${sanitized_channel_name}/${sanitized_playlist_name}"
if [ ! -d "${video_folder}" ]; then
    mkdir -p "${video_folder}"
fi
video_file="${video_folder}/${video_id}.mp4"

# Generate a unique container name based on the video ID 
container_name="${video_id}"

# Download video using docker run command in detached mode and delete the container when finished
docker run \
    --rm -d \
    -e PGID=$(id -g) \
    -e PUID=$(id -u) \
    -v "$(sanitize_folder "$MEDIA")":/workdir:rw \
    -v "$(sanitize_folder "$video_folder")":/output:rw \
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

