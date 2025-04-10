#!/bin/bash

# Check if at least the input URL was provided as an argument
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <youtube-url> [output-file]"
    exit 1
fi

# Set default output file if not provided
output_file="${2:-output.mp4}"

# Run yt-dlp with the input URL
yt-dlp "$1" -o "$output_file" --no-playlist --merge-output-format mp4 --postprocessor-args "-strict -2"
