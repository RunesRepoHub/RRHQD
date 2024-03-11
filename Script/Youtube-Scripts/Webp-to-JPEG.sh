#!/bin/bash

source ~/RRHQD/Core/Core.sh



# get list of subfolders in ~/plex/media/youtube
subfolders=(~/plex/media/youtube/*)

# create array with folder names only
folders=()
for folder in "${subfolders[@]}"; do
    folders+=("${folder##*/}")
done

# show dialog to select one of the folders
selected_folder=$(dialog --title "Select Folder" --menu "Choose a folder" 20 75 15 "${folders[@]}" 2>&1 >/dev/tty)

# exit if nothing was selected
if [ -z "$selected_folder" ]; then
    exit 0
fi



# install cwebp if not already installed
if ! command -v cwebp &> /dev/null; then
    sudo apt-get install -y webp
fi


# find all webp files in all subfolders
find "$selected_folder" -type f -name '*.webp' -print0 |
    while IFS= read -r -d '' file; do
        # get filename without extension
        filename=$(basename "$file" .webp)
        # convert webp to jpeg
        cwebp -quiet "$file" -o "${file%.*}.jpeg"
    done


# check if the conversion was successful or if it failed
if [ "$(find "$selected_folder" -type f -name '*.jpeg' | wc -l)" -lt "$(find "$selected_folder" -type f -name '*.webp' | wc -l)" ]; then
    dialog --title "Error" --msgbox "Failed to convert all WebP images to JPEG. Please check the logs for details." 6 60
else
    dialog --title "Success" --msgbox "All WebP images have been converted to JPEG." 6 60
fi



