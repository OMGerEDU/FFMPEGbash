#Download Audio Bulk from .txt file to destination folder.

#!/bin/bash

# Check if the required arguments are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <urls-file-path> <destination-folder>"
  exit 1
fi

# Set the input file and destination folder
URLS_FILE="$1"
DEST_FOLDER="$2"

# Check if the file exists
if [ ! -f "$URLS_FILE" ]; then
  echo "The file '$URLS_FILE' does not exist."
  exit 1
fi

# Check if the destination folder exists, create if not
if [ ! -d "$DEST_FOLDER" ]; then
  echo "Destination folder '$DEST_FOLDER' does not exist. Creating it..."
  mkdir -p "$DEST_FOLDER"
fi

# Read each URL from the file and download it
while IFS= read -r URL; do
  if [ -n "$URL" ]; then
    echo "Downloading from URL: $URL"
    yt-dlp -x --audio-format mp3 -o "$DEST_FOLDER/%(title)s.%(ext)s" "$URL"
  fi
done < "$URLS_FILE"

# Inform the user that the downloads are complete
echo "All downloads complete! Files are saved in '$DEST_FOLDER'."
