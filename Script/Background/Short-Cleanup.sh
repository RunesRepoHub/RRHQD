#!/bin/bash

source ~/RRHQD/Core/Core.sh


for file in ~/plex/media/youtube/**/*.webm; do
    if [ $(du -b "$file" | cut -f1) -lt 94371840 ]; then
        echo "$file is less then 90mb"
        file="${file%.webm}"
        
        if [[ $file != *"/NeebsGaming/"* ]]; then

        rm "$file.webm"
        rm "$file.description"
        rm "$file.info.json"
        rm "$file.en.srt"
        rm "$file.jpeg"
        fi
    fi
done

for file in ~/plex/media/youtube/**/*.mkv; do
    if [ $(du -b "$file" | cut -f1) -lt 94371840 ]; then
        echo "$file is less then 90mb"
        file="${file%.mkv}"
        filename="${file%/*}/"

        if [[ $file != *"/NeebsGaming/"* ]]; then

        rm "$file.mkv"
        rm "$file.description"
        rm "$file.info.json"
        rm "$file.en.srt"
        rm "$file.jpeg"
        fi
    fi  
done

for file in ~/plex/media/youtube/**/*.mp4; do
    if [ $(du -b "$file" | cut -f1) -lt 94371840 ]; then
        echo "$file is less then 90mb"
        file="${file%.mp4}"

        if [[ $file != *"/NeebsGaming/"* ]]; then
        
        rm "$file.mp4"
        rm "$file.description"
        rm "$file.info.json"
        rm "$file.en.srt"
        rm "$file.jpeg"
        fi
    fi
done


