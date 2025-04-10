#!/bin/bash
set +e

# Check if the correct number of arguments are provided
if [ "$#" -lt 2 ] || [ "$#" -gt 4 ]; then
    echo "Usage: $0 <youtube-url> <output-file-path> [start-time] [end-time]"
    echo "start-time and end-time are optional, format is in seconds"
    exit 1
fi

# Assign arguments to variables
YOUTUBE_URL="$1"
OUTPUT_FILE="$2"
START_TIME="$3"
END_TIME="$4"

# Delete existing file if it exists
if [ -f "$OUTPUT_FILE" ]; then
    rm "$OUTPUT_FILE"
    echo "Existing file deleted."
    sleep 1  # Sleep for 1 second
fi

# Ensure the output directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

# If start and end time are provided, use yt-dlp to download the specific segment
if [ -z "$START_TIME" ] || [ -z "$END_TIME" ]; then
    # Download the entire video without trimming if no time range is provided
    yt-dlp -v --no-playlist -o "$OUTPUT_FILE" --merge-output-format mp4 "$YOUTUBE_URL"
else
    # Download the video and trim it using yt-dlp's postprocessor args
    yt-dlp -v --no-playlist -o "$OUTPUT_FILE" --merge-output-format mp4 \
      "$YOUTUBE_URL" --postprocessor-args "-ss $START_TIME -to $END_TIME"
fi

# Check if the download and trimming was successful
if [ $? -ne 0 ]; then
    echo "Failed to download and trim video."
    exit 1
fi

# Resize the video using ffmpeg (optional, you can skip this if not needed)
TEMP_FILE="$(dirname "$OUTPUT_FILE")/temp.mp4"
# Add -y to auto delete the already existing temp file if it exists
ffmpeg -y -i "$OUTPUT_FILE" -vf scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:\(ow-iw\)/2:\(oh-ih\)/2 -aspect 9:16 -c:v libx264 -preset faster -crf 23 -c:a aac -b:a 128k "$TEMP_FILE"

# Check if ffmpeg succeeded
if [ $? -ne 0 ]; then
    echo "Failed to resize video."
    exit 1
fi

# Move the temp file to the final output file
mv "$TEMP_FILE" "$OUTPUT_FILE"

echo "Video successfully downloaded, trimmed, and resized: $OUTPUT_FILE"
exit 0
