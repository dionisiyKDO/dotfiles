# Dotfiles

This repository contains my dotfiles for EndeavourOS and other Linux setups. It was originally for NixOS but has been repurposed for general Linux configurations while keeping a `nix/` folder for NixOS-specific files in case I revisit it.

## Structure
```
.
├── hyprland/       # Hyprland configuration
├── waybar/         # Waybar configuration
├── scripts/        # Custom scripts
├── nix/            # NixOS-specific configurations (left for future use)
└── README.md       # This file
```

## Managing Dotfiles
- Use symlinks to keep configurations in `~/.config/` while tracking them in this repository.
- Keep application-specific configurations in their respective folders (e.g., `hyprland/`, `waybar/`).
- Store general scripts in `scripts/`.
- The `nix/` folder remains for NixOS-specific setups if I return to it.

## Installation
To set up the dotfiles on a new system:
```bash
# Clone the repo
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles

# Create symlinks
stow hyprland waybar scripts -t ~
```
