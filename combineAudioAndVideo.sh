#!/bin/bash

# Navigate to the directory containing the files
cd "D:\Downloads\New folder (3)"

# Initialize variables
video_file=""
audio_file=""

# Loop through all mp4 files
for file in *.mp4; do
  # Check if the file has a video stream
  if ffprobe -v error -select_streams v:0 -show_entries stream=codec_type -of csv=p=0 "$file" | grep -q "video"; then
    # Assign the first video file found
    if [ -z "$video_file" ]; then
      video_file="$file"
    fi
  # Otherwise, check if the file has an audio stream
  elif ffprobe -v error -select_streams a:0 -show_entries stream=codec_type -of csv=p=0 "$file" | grep -q "audio"; then
    # Assign the first audio file found
    if [ -z "$audio_file" ]; then
      audio_file="$file"
    fi
  fi
done

# Combine the video and audio into a single file, if both are found
if [ -n "$video_file" ] && [ -n "$audio_file" ]; then
  ffmpeg -i "$video_file" -i "$audio_file" -c:v copy -c:a aac -strict experimental output.mp4
  echo "Combining $video_file and $audio_file into output.mp4"
else
  echo "Could not find suitable video and audio files."
fi

echo "Processing complete."
