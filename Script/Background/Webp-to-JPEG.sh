# install cwebp if not already installed
if ! command -v cwebp &> /dev/null; then
    sudo apt-get install -y webp
fi

# find all webp files in all subfolders
find ~/plex/media/youtube -type f -name '*.webp' -print0 |
    while IFS= read -r -d '' file; do
        # get filename without extension
        filename=$(basename "$file" .webp)
        # convert webp to jpeg
        cwebp -quiet "$file" -o "${file%.*}.jpeg"
        # remove webp files
        rm "$file"
    done