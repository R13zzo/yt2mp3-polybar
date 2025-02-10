# YouTube 2 MP3 Downloader Script

This script allows you to download YouTube videos as MP3 files using `yt-dlp`. It uses a graphical prompt (via `zenity`) to ask for the YouTube video URL and saves the MP3 in a specified directory (`/home/****/Music/`).

### Prerequisites

Before using the script, ensure that you have the following installed:

**yt-dlp**: A powerful video downloader and extractor.

- Install via pip:
    
    ```
    pip install yt-dlp
    ```
    

**zenity**: A utility that provides GTK-based dialog boxes for shell scripts.

- Install via your package manager (e.g., on Ubuntu):
    
    ```
    sudo apt install zenity
    ```
    

**notify-send**: For sending notifications upon successful or failed downloads.

- Install via:
    
    ```
    sudo apt install libnotify-bin
    ```
    

### Usage

1. **Download the Script:**
    
    Save the script as `download_mp3.sh` in your preferred directory, e.g., `/home/****/bin/download_mp3.sh`.
    
2. **Make the Script Executable:**
    
    Once you've saved the script, give it execute permission:
    
    ```
    chmod +x /home/riezzo/bin/download_mp3.sh
    ```
    

1. **Run the Script:**

You can run the script directly from the terminal or as a Polybar module (see Polybar section below). The script will prompt you for the YouTube URL and download the MP3 to `/home/****/Music/`.

```
/home/riezzo/bin/download_mp3.sh
```

It will prompt you with a `zenity` dialog to enter the YouTube video URL. After you provide the URL, the script will download the MP3 to your `Music` folder.

### Script Details

The script performs the following actions:

1. **Prompt for YouTube URL**: The script uses `zenity` to display a GTK-based entry dialog that asks for the YouTube video URL.
2. **Validation**: The script ensures that the URL is not empty.
3. **Download MP3**: Uses `yt-dlp` to download the audio from the video and save it as an MP3 file.
4. **Notifications**: After the download completes, it sends a desktop notification using `notify-send`.

### Example Script (`download_mp3.sh`)

```bash
#!/bin/bash

# Directory to save the music
TARGET_DIR="/home/riezzo/Music/"

# Check if the target directory exists, if not, create it
if [ ! -d "$TARGET_DIR" ]; then
  echo "Directory $TARGET_DIR does not exist. Creating it now."
  mkdir -p "$TARGET_DIR"
fi

# Prompt user for the YouTube URL using zenity
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
```

### 

### Polybar Integration

To use the script as a **Polybar module** that triggers the download when clicked, add the following to your Polybar configuration file (`~/.config/polybar/config`):

```
[module=youtube-downloader]
type = custom/script
exec = echo "Click to download MP3"
click-left = /home/riezzo/bin/download_mp3.sh
label = 📥 Download MP3
```

- **exec**: Displays "Click to download MP3" on the Polybar.
- **click-left**: Executes the `download_mp3.sh` script when the module is clicked.

Reload Polybar to apply the changes:

```
polybar-msg cmd restart
```

### Notes

- The script is designed to download the audio in MP3 format and save it to the `/home/****/Music/` directory. If this directory does not exist, it will be created automatically.
- You can modify the script to change the download directory by editing the `TARGET_DIR` variable.
- Ensure that the required packages (`yt-dlp`, `zenity`, and `notify-send`) are installed.
