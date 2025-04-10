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
tempOutputFileName="subs_temp.%(ext)s"
outputFileName="${title}.srt"

# Full paths
tempFilePathPattern="${outputPath}/${tempOutputFileName}"
newPath="${outputPath}/${outputFileName}"

# Delete existing .srt file if it exists
if [ -f "$newPath" ]; then
    rm "$newPath"
    echo "Existing subtitle file deleted."
    sleep 1  # Sleep for 1 second
fi

# Run yt-dlp to download subtitles
yt-dlp --no-playlist "$videoUrl" --write-subs --sub-langs "en" --convert-subs srt --skip-download --output "$tempFilePathPattern"

# Wait for file system to settle
sleep 1

# Attempt to rename the downloaded subtitle file
for file in "${outputPath}/"subs_temp.*.srt; do
    if [ -f "$file" ]; then
        mv "$file" "$newPath"
        echo "Subtitles downloaded and renamed successfully to ${newPath}"
        break
    else
        echo "No subtitles were downloaded."
    fi
done
