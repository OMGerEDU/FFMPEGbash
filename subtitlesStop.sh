#!/bin/bash

# Usage check
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <videoUrl> <outputPath> [<title>]"
    exit 1
fi

videoUrl="$1"
outputPath="$2"
title="${3:-subtitles}"  # Default title is 'subtitles' if not provided

# Define the temporary and final output filenames
tempOutputFileName="subs_temp"
outputFileName="${title}.srt"

# Full paths
tempFilePathPattern="${outputPath}/${tempOutputFileName}.%(ext)s"
newPath="${outputPath}/${outputFileName}"

# Delete existing .srt file if it exists
if [ -f "$newPath" ]; then
    rm "$newPath"
    echo "Existing subtitle file deleted."
    sleep 1  # Sleep for 1 second
fi

# First, check available subtitles
yt-dlp --list-subs "$videoUrl" | grep 'Available subtitles for' && {
    # If available, run yt-dlp to download subtitles
    yt-dlp --no-playlist "$videoUrl" --write-subs --sub-langs "en" --convert-subs srt --skip-download --output "$tempFilePathPattern"
} || {
    echo "No available subtitles for the specified language."
    exit 1
}

# Wait for file system to settle
sleep 1

# Attempt to rename the downloaded subtitle file
found_sub=false
for file in "${outputPath}/"subs_temp.*.srt; do
    if [ -f "$file" ]; then
        mv "$file" "$newPath"
        echo "Subtitles downloaded and renamed successfully to ${newPath}"
        found_sub=true
        break
    fi
done

if [ "$found_sub" = false ]; then
    echo "No subtitles were downloaded."
    exit 1
fi



echo "Setup completed successfully."
read -p "Press enter to continue"