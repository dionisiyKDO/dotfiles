#!/bin/bash

# Define the dotfiles directory (assuming the script is run from the repo root)
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BACKUP_DIR="$HOME/Desktop/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# List of files and their target locations
declare -A FILES_TO_SYMLINK=(
    # ["nix"]="$HOME/.config/nix"
    ["hypr"]="$HOME/.config/hypr"
    ["swaylock"]="$HOME/.config/swaylock"
    ["waybar"]="$HOME/.config/waybar"
    ["alacritty"]="$HOME/.config/alacritty"
    ["rofi"]="$HOME/.config/rofi"
    ["tofi"]="$HOME/.config/tofi"
    ["dunst"]="$HOME/.config/dunst"
    ["quickshell"]="$HOME/.config/quickshell"
    ["eww"]="$HOME/.config/eww"
    ["niri"]="$HOME/.config/niri"

    ["scripts"]="$HOME/scripts"

    # [".oh-my-zsh/custom"]="$HOME/.oh-my-zsh/custom"
    [".zshrc"]="$HOME/.zshrc"
    [".zprofile"]="$HOME/.zprofile"
)

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "Backing up existing dotfiles to: $BACKUP_DIR"

for file in "${!FILES_TO_SYMLINK[@]}"; do
    target="${FILES_TO_SYMLINK[$file]}"
    source="$DOTFILES_DIR/$file"

    # Backup existing files
    if [ -e "$target" ] || [ -L "$target" ]; then
        mv "$target" "$BACKUP_DIR/"
        echo "Backed up $target to $BACKUP_DIR/"
    fi

    # Ensure parent directories exist
    mkdir -p "$(dirname "$target")"

    # Create symlink
    ln -s "$source" "$target"
    echo "Symlinked $source -> $target"
done

echo "Dotfiles installation complete."
