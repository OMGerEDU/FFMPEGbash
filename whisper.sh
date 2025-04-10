#!/bin/bash
set +e

# Ensure script is executed with a YouTube URL as the first argument
if [ -z "$1" ]; then
  echo "Usage: $0 <YouTube URL> <Path for Files> <Output subtitles name>"
  exit 1
fi

# Ensure script is executed with a path as the second argument
if [ -z "$2" ]; then
  echo "Usage: $0 <YouTube URL> <Path for Files>"
  exit 1
fi

# Assign arguments to variables
YOUTUBE_URL=$1
OUTPUT_DIR=$2
SUBTITLE_OUTPUT=$3

AUDIO_OUTPUT="$OUTPUT_DIR/audio.wav"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Change to the specified output directory
cd "$OUTPUT_DIR"

if [ -f "$AUDIO_OUTPUT" ]; then
  echo "Removing existing audio file: $AUDIO_OUTPUT"
  rm "$AUDIO_OUTPUT"
fi

# Download only the audio from YouTube
echo "Downloading audio from $YOUTUBE_URL..."
yt-dlp -x --audio-format wav --audio-quality 0 -o "$AUDIO_OUTPUT" "$YOUTUBE_URL"

if [ ! -f "$AUDIO_OUTPUT" ]; then
  echo "Audio download failed!"
  exit 1
fi

# Generate transcript using Whisper
echo "Generating transcript..."
whisper "$AUDIO_OUTPUT" --model small --language en --output_format srt --output_dir "$OUTPUT_DIR"

# Rename the generated subtitle file to the desired output name
DEFAULT_SUBTITLE="$OUTPUT_DIR/audio.srt"
if [ -f "$DEFAULT_SUBTITLE" ]; then
  mv "$DEFAULT_SUBTITLE" "$SUBTITLE_OUTPUT"
else
  echo "Transcript generation failed!"
  exit 1
fi

echo "Transcript successfully generated at $SUBTITLE_OUTPUT"

# Clean up
echo "Cleaning up..."
rm "$AUDIO_OUTPUT"

echo "Done."
#read -p "Press any key to continue..."
