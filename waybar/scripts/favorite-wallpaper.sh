#!/bin/bash

# Ensure swww daemon is running
pgrep -x swww || swww daemon &

# Select a random wallpaper from the directory
WALLPAPERS_DIR=~/Pictures/Wallpapers/SFW/
RANDOM_WALLPAPER=$(find "$WALLPAPERS_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

CHANGE_DURATION=1

# Ensure wallpaper is not empty
if [[ -z "$RANDOM_WALLPAPER" ]]; then
    echo "No wallpaper found in $WALLPAPERS_DIR" >> ~/wallpaper_debug.log
    exit 1
fi



# Change wallpaper with swww and transition effect
swww img "$RANDOM_WALLPAPER" --transition-type wipe --transition-fps 144 --transition-duration $CHANGE_DURATION

# Wait for transition
sleep $CHANGE_DURATION

# Apply new color scheme using pywal
wal -i "$RANDOM_WALLPAPER" -q
source ~/.cache/wal/colors.sh

# Restart Waybar to apply new colors1
# pkill waybar
# waybar &
pkill -SIGUSR2 waybar &
notify-send "Wallpaper Changed" "$(basename "$RANDOM_WALLPAPER")" -i "$RANDOM_WALLPAPER"
