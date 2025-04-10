#!/bin/bash

# Check if a directory path was provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 /path/to/your/videos"
    exit 1
fi

# Change to the specified directory
cd "$1" || exit

# Ensure Node.js 'he' library is installed (you can also install it globally if needed)
npm install he --save >/dev/null 2>&1

# Iterate over each MP4 file in the current directory
for video in *.mp4; do
    # Corresponding SRT file
    srt="${video%.mp4}.srt"

    # Check if the SRT file exists
    if [[ -f "$srt" ]]; then
        # Pre-process the SRT file to decode HTML entities using Node.js
        node -e "const fs = require('fs'); const he = require('he'); let srtContent = fs.readFileSync('$srt', 'utf8'); let decodedContent = he.decode(srtContent); fs.writeFileSync('$srt', decodedContent);"

        # Temporary output file path
        temp_output="${video%.mp4}_temp.mp4"

        # Log starting
        echo "Starting to burn subtitles for $video"

        # Command to burn subtitles
        ffmpeg -y -i "$video" -vf "subtitles='$srt':force_style='FontName=BankGothic Md BT,FontSize=20,PrimaryColour=&H888D218,OutlineColour=&H00000000,BorderStyle=1,Outline=2,Shadow=0,Bold=1'" -c:v libx264 -crf 23 -preset fast "$temp_output"

        # Check if ffmpeg succeeded
        if [ $? -eq 0 ]; then
            echo "Successfully burned subtitles into $temp_output"
            # Replace the original file with the temp file
            mv "$temp_output" "$video"
            echo "Updated original video file with subtitles: $video"
            # Delete the SRT file
            rm "$srt"
            echo "Deleted SRT file: $srt"
        else
            echo "Failed to burn subtitles into $video"
            # Remove the temporary file if ffmpeg failed
            rm "$temp_output"
        fi
    else
        echo "No SRT file found for $video"
    fi
done

#echo "All specified videos have been processed."
#read -p "Press enter to continue"
