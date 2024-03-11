#!/bin/bash

source ~/RRHQD/Core/Core.sh


# count amount of webp files to convert
NUM_FILES=$(find ~/plex/media/youtube -type f -name '*.webp' | wc -l)

dialog --title "Converting WebP images to JPEG" --yesno "This will convert $NUM_FILES WebP images to JPEG. Proceed?" 8 60
proceed=$?

if [ $proceed -eq 0 ]; then
    echo -e "\nConverting WebP images to JPEG...\n"
else
    echo -e "\nExiting without converting WebP images to JPEG.\n"
    exit 0
fi

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
        NUM_FILES=$((NUM_FILES - 1))
    done


# check if the conversion was successful or if it failed
if [ "$(find ~/plex/media/youtube -type f -name '*.jpeg' | wc -l)" -lt "$(find ~/plex/media/youtube -type f -name '*.webp' | wc -l)" ]; then
    dialog --title "Error" --msgbox "Failed to convert all WebP images to JPEG. Please check the logs for details." 6 60
else
    dialog --title "Success" --msgbox "All WebP images have been converted to JPEG." 6 60
fi



