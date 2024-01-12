# Prompt user to enter the desired output path for the downloaded video
read -p "Enter the output path for the downloaded video: " output_path

read -p "Enter the link for the YouTube playlist: " url

MEDIA=~/plex/media

# Extract the playlist ID from the URL
playlist_id=$(echo "${url}" | awk -F '[=&]' '{print $2}')

# Get the channel name using youtube-dl with Docker
channel_name=$(docker run --rm mikenye/youtube-dl --get-filename -o "%(channel)s" -- "${url}" | head -n 1)

# Get the playlist name using youtube-dl with Docker
playlist_name=$(docker run --rm mikenye/youtube-dl --get-filename -o "%(playlist)s" -- "${url}" | head -n 1)

# If the playlist name is not available, default to 'no_playlist'
playlist_name=${playlist_name:-no_playlist}

# Create the playlist folder if it doesn't exist
playlist_folder="${output_path}/${channel_name}/${playlist_name}/"

if [ ! -d "${playlist_folder}" ]; then
    mkdir -p "${playlist_folder}"
fi

# Generate a unique container name based on the playlist ID
container_name="playlist_${playlist_id}"

# Check if a container with the same playlist ID is already running
if docker ps --filter "name=${container_name}" --format '{{.Names}}' | grep -q "${container_name}"; then
    echo "A download for this playlist is already in progress."
    exit 0
fi

# Download playlist using docker run command in detached mode and delete the container when finished
docker run \
    --rm -d \
    -e PGID=$(id -g) \
    -e PUID=$(id -u) \
    -v "$MEDIA":/workdir:rw \
    -v "${playlist_folder}":/output:rw \
    --name "${container_name}" \
    --cpus 1 \
    --memory 2g \
    mikenye/youtube-dl -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' \
    --yes-playlist \
    --write-info-json \
    --write-thumbnail \
    --write-description \
    --write-sub \
    --embed-subs \
    --convert-subs srt \
    --write-auto-sub \
    --download-archive "${playlist_folder}/download-archive.txt" \
    --output '/output/%(title)s.%(ext)s' \
    "${url}"

# Notify the user that the download has started
dialog --title "Download Started" --msgbox "The download for playlist ID ${playlist_id} has started. Please wait..." 6 50

