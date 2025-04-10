#!/bin/bash

# Parameters
WATERMARK_PATH="$1"
VIDEO_PATH="$2"
OUTPUT_PATH="${VIDEO_PATH%.*}_with_watermark.mp4"
WATERMARK_POSITION="${3:-"bottom-right"}"
WATERMARK_TRANSPARENCY="${4:-1.0}"

# Calculate the watermark position
case "$WATERMARK_POSITION" in
  "top-left")
    POSITION="x=20:y=20"
    ;;
  "top-right")
    POSITION="x=W-w-20:y=20"
    ;;
  "bottom-left")
    POSITION="x=20:y=H-h-20"
    ;;
  "bottom-right")
    POSITION="x=W-w-20:y=H-h-20"
    ;;
  *)
    echo "Invalid watermark position. Choose from: top-left, top-right, bottom-left, bottom-right."
	sleep 5
    exit 1
    ;;
esac


# Run FFmpeg command with watermark scaling
ffmpeg -i "$VIDEO_PATH" -i "$WATERMARK_PATH" \
  -filter_complex "[1]scale=120:-1[watermark];[watermark]format=rgba,colorchannelmixer=aa=${WATERMARK_TRANSPARENCY}[wm];[0][wm]overlay=$POSITION" \
  -c:v libx264 -crf 18 -preset veryslow "$OUTPUT_PATH"



## Run FFmpeg command to add watermark with transparency - replaced with above, if it suddenly doesn't work, you know why.
#ffmpeg -i "$VIDEO_PATH" -i "$WATERMARK_PATH" \
#  -filter_complex "[1]format=rgba,colorchannelmixer=aa=${WATERMARK_TRANSPARENCY}[wm];[0][wm]overlay=$POSITION" \
#  -c:v libx264 -crf 18 -preset veryslow "$OUTPUT_PATH"

# Replace the original video with the watermarked one if the process was successful
if [ -f "$OUTPUT_PATH" ]; then
  rm "$VIDEO_PATH"
  mv "$OUTPUT_PATH" "$VIDEO_PATH"
  echo "Watermark added successfully to the video. Output file: $VIDEO_PATH"
else
  echo "Error: Failed to create the output file. Something went wrong."
  sleep 5
  exit 1
fi
