#!/bin/bash
# specific-wallpaper.sh - Sets a specific wallpaper, runs pywal, and reloads waybar

# Ensure swww daemon is running
pgrep -x swww || swww daemon &

# Select a random wallpaper from the directory
SPECIFIC_WALLPAPER="$HOME/Pictures/Wallpapers/wallhaven-6d3zkl_1920x1080.png"
CHANGE_DURATION=1

# Ensure wallpaper is not empty
if [[ -z "$SPECIFIC_WALLPAPER" ]]; then
    echo "Error" "Wallpaper not found: $(basename "$SPECIFIC_WALLPAPER")"
    exit 1
fi

# Change wallpaper with swww and transition effect
swww img "$SPECIFIC_WALLPAPER" --transition-type wipe --transition-fps 144 --transition-duration $CHANGE_DURATION

# Wait for transition
sleep $CHANGE_DURATION

# Apply new color scheme using pywal
wal -i "$SPECIFIC_WALLPAPER" -q
source ~/.cache/wal/colors.sh

# Restart Waybar to apply new colors1
# pkill waybar
# waybar &
pkill -SIGUSR2 waybar &
notify-send "Wallpaper Changed" "Set to: $(basename "$SPECIFIC_WALLPAPER")" -i "$SPECIFIC_WALLPAPER"