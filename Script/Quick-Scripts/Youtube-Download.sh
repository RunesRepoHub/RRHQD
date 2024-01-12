# Prompt user to enter the desired output path for the downloaded video
read -p "Enter the output path for the downloaded video: " output_path

read -p "Link for youtube playlist" url

MEDIA=~/plex/media

# Extract the video ID from the URL
video_id=$(echo "${url}" | awk -F '[=&]' '{print $2}')

# Get the channel name using youtube-dl with Docker
channel_name=$(docker run --rm mikenye/youtube-dl --get-filename -o "%(channel)s" "${url}" | head -n 1)

# Get the playlist name using youtube-dl with Docker
playlist_name=$(docker run --rm mikenye/youtube-dl --get-filename -o "%(playlist)s" "${url}" | head -n 1)

# If the playlist name is not available, default to 'no_playlist'
playlist_name=${playlist_name:-no_playlist}
    
# Create the video folder if it doesn't exist
video_folder="${output_path}/${channel_name}/${playlist_name}/"
video_file="${video_folder}/$(echo "${url}" | awk -F '=' '{print $2}').mp4"

# Create the video folder if it doesn't exist
if [ ! -d "${video_folder}" ]; then
    mkdir -p "${video_folder}"
fi
video_file="${video_folder}/${video_id}.mp4"


# Check if the container with the same video ID is already running
if docker ps --filter "name=${video_id}" --format '{{.Names}}' | grep -q "${video_id}"; then
    exit 0
fi

# Generate a unique container name based on the video ID 
container_name="${video_id}"

# Download video using docker run command in detached mode and delete the container when finished
docker run \
    --rm -d \
    -e PGID=$(id -g) \
    -e PUID=$(id -u) \
    -v "$MEDIA":/workdir:rw \
    -v "${video_folder}":/output:rw \
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

# Notify the user that the download has started
dialog --title "Download Started" --msgbox "The download for video ID ${video_id} has started. Please wait..." 6 50
