#!/bin/bash

source ~/RRHQD/Core/Core.sh


# count amount of webp files to convert
NUM_FILES=$(find ~/plex/media/youtube -type f -name '*.webp' | wc -l)

printf "Converting %s WebP images to JPEG..." "$NUM_FILES"

# install cwebp if not already installed
if ! command -v cwebp &> /dev/null; then
    sudo apt-get install -y webp
fi


# find all webp files in all subfolders
find ~/plex/media/youtube -type f -name '*.webp' -print0 |
    pv -lt > /dev/null |
    while IFS= read -r -d '' file; do
        # get filename without extension
        filename=$(basename "$file" .webp)
        # convert webp to jpeg
        cwebp -quiet "$file" -o "${file%.*}.jpeg" &
        NUM_FILES=$((NUM_FILES - 1))
    done |
    pv -N "Converting to JPEG: " -l $((NUM_FILES)) > /dev/null


# check if the conversion was successful or if it failed
if [ "$(find ~/plex/media/youtube -type f -name '*.jpeg' | wc -l)" -lt "$(find ~/plex/media/youtube -type f -name '*.webp' | wc -l)" ]; then
    dialog --title "Error" --msgbox "Failed to convert all WebP images to JPEG. Please check the logs for details." 6 60
else
    dialog --title "Success" --msgbox "All WebP images have been converted to JPEG." 6 60
fi



