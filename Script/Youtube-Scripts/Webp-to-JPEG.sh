#!/bin/bash

# Ask user to pick a folder/subfolders
echo "Enter the path of the folder/subfolders you want to convert the webp files into jpeg:"
read -r folderPath

# Check if folderPath is a valid directory
if [ ! -d "$folderPath" ]; then
  echo "Invalid directory. Please try again."
  exit
fi

# Loop through all subfolders and files in the folder
# We use find instead of a "for" loop because it can handle subfolders
find "$folderPath" -type f -name "*.webp" -exec bash -c 'webp -q 80 -m -o "${0%.webp}.jpeg" "{}"' {} \;

# Inform the user that the script is finished
echo "Conversion finished."

