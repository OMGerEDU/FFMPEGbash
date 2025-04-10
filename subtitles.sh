#!/bin/bash

# Usage check
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <videoUrl> <outputPath> [<title>]"
    exit 1
fi

videoUrl="$1"
outputPath="$2"
title="${3:-subtitles}"  # Default title if not provided

# Define the temporary and final output filenames
tempOutputFileName="subs_temp"
outputFileName="${title}"

# Full paths
tempFilePathPattern="${outputPath}/${tempOutputFileName}.%(ext)s"

newPath="${outputPath}/${outputFileName}"
echo "${newPath}"
# Delete existing .srt file if it exists
if [ -f "$newPath" ]; then
    rm "$newPath"
    echo "Existing subtitle file deleted."
    sleep 1  # Sleep for 1 second
fi

# Download all available English subtitles (manual and auto)
yt-dlp "$videoUrl" --no-playlist --write-subs --write-auto-subs --sub-langs "en" --sub-format "srt" --skip-download --output "$tempFilePathPattern"

# Wait for file system to settle
sleep 1

# Check how many .srt files have been downloaded and merge them if there are multiple
srt_files=($(find "${outputPath}" -name "${tempOutputFileName}*.srt"))
if [ ${#srt_files[@]} -eq 0 ]; then
    echo "No subtitles were downloaded."
    exit 1
elif [ ${#srt_files[@]} -eq 1 ]; then
    # Only one subtitle file, just rename it
    mv "${srt_files[0]}" "$newPath"
    echo "Subtitles downloaded and saved to ${newPath}"
else
    # Multiple subtitle files, merge them
    echo "Merging subtitle files..."
    for file in "${srt_files[@]}"; do
        cat "$file" >> "$newPath"
        echo "" >> "$newPath"  # Ensure there is a newline between subtitle files
    done
    echo "Subtitles merged and saved to ${newPath}"
fi
