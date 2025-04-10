#!/bin/bash
set +e

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <youtube-url>"
    exit 1
fi

# Assign the URL from the first argument
YOUTUBE_URL="$1"

# Define the output filename format
OUTPUT_FILE_FORMAT="%(title)s.%(ext)s"

# Download the video using yt-dlp with specified parameters
echo "Downloading video without audio from $YOUTUBE_URL ..."
yt-dlp -v --no-playlist  --merge-output-format mp4 "$YOUTUBE_URL"

# Check if yt-dlp succeeded
if [ $? -ne 0 ]; then
    echo "Failed to download video."
    exit 1
fi

echo "Video download complete."

exit 0
