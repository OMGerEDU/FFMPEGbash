#!/bin/bash

# Input and output directories
INPUT_DIR="./"
OUTPUT_DIR="./watermarked_images"

# Path to the Arial font file in the current directory
FONT_PATH="arial.ttf"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Initialize iterator
iterator=1

# Process all .png, .jpg, and .jpeg images in the directory
for file in "$INPUT_DIR"/*.png "$INPUT_DIR"/*.jpg "$INPUT_DIR"/*.jpeg; do
  # Skip if the file doesn't exist
  [ -e "$file" ] || continue

  # Generate the watermark text
  watermark="Type $iterator"

  # Create the output file path
  output_file="$OUTPUT_DIR/$(basename "$file")"

  # Add watermark using FFmpeg with hardcoded font path
  ffmpeg -i "$file" \
    -vf "drawtext=fontfile='$FONT_PATH':text='$watermark':x=w-tw-10:y=h-th-10:fontsize=60:fontcolor=white:box=1:boxcolor=black@0.8" \
    -y "$output_file"

  # Increment the iterator
  iterator=$((iterator + 1))
done

echo "Watermarking complete. Files saved in $OUTPUT_DIR."
