# Dotfiles

This repository contains my dotfiles for EndeavourOS and other Linux setups. It was originally for NixOS but has been repurposed for general Linux configurations while keeping a `nix/` folder for NixOS-specific files in case I revisit it.

## Structure
```
.
├── hyprland/       # Hyprland configuration
├── waybar/         # Waybar configuration
├── nix/            # NixOS-specific configurations (left for future use)
└── README.md       # This file
```

## Installation
To set up the dotfiles on a new system:
```bash
# Clone the repo
git clone https://github.com/dionisiyKDO/dotfiles.git ~/dotfiles

# Create symlinks
stow hyprland waybar scripts -t ~
```
