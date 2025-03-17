{ config, lib, pkgs, ... }:

{
  programs.waybar.enable = true;
  
  home.file = {
    ".config/waybar/config.jsonc" = {
      source = ./waybar/config.jsonc;
    };
    ".config/waybar/style.css" = {
      source = ./waybar/style.css;
    };

    # TODO: Doesn't work. Try to find why
    # It doesn't create link in ~/.config/waybar/scripts
    # ".config/waybar/scripts/random-wallpaper.sh" = {
    #   source = ./waybar/scripts/random-wallpaper.sh;
    #   executable = true;
    # };
    # ".config/waybar/scripts/favorite-wallpaper.sh" = {
    #   source = ./waybar/scripts/favorite-wallpaper.sh;
    #   executable = true;
    # };
  };
}
