#!/bin/bash

# Directory to save the music
TARGET_DIR="/home/riezzo/Music/"

# Check if the target directory exists, if not, create it
if [ ! -d "$TARGET_DIR" ]; then
  echo "Directory $TARGET_DIR does not exist. Creating it now."
  mkdir -p "$TARGET_DIR"
fi

# Prompt user for the YouTube URL
URL=$(zenity --entry --title="YouTube URL" --text="Enter the YouTube URL:")

# Validate if the URL is not empty
if [ -z "$URL" ]; then
  echo "Error: You must enter a valid YouTube URL."
  exit 1
fi

# Download the video as MP3 using yt-dlp
yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --output "$TARGET_DIR/%(title)s.%(ext)s" "$URL"

# Notify the user
if [ $? -eq 0 ]; then
  notify-send "Download complete!" "The MP3 is saved in $TARGET_DIR."
else
  notify-send "Download failed" "There was an error during download."
  exit 1
fi


