#!/bin/bash

source ~/RRHQD/Core/Core.sh

# find all webp files in all subfolders
find ~/plex/media/youtube -type f -name '*.webp' -print0 |
    while IFS= read -r -d '' file; do
        # get filename without extension
        filename=$(basename "$file" .webp)
        # convert webp to jpeg
        cwebp -quiet "$file" -o "${file%.*}.jpeg"
        # remove the original webp file
        rm "$file"
    done

        if [ $? -eq 0 ]; then
            dialog --title "Success" --msgbox "All webp images converted to jpeg successfully." 6 50
        else
            dialog --title "Failure" --msgbox "One or more webp images failed to convert to jpeg." 6 50
        fi

