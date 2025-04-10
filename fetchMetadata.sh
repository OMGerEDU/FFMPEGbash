#!/bin/bash

# Check if the URL is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <videoUrl>"
    exit 1
fi

videoUrl="$1"

# Fetch and return metadata as JSON
yt-dlp --no-playlist -j "$videoUrl"
