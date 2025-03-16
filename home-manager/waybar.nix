{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    
    home.file = {
      ".config/waybar/config.jsonc".source = ./waybar/config.jsonc;
      ".config/waybar/style.css".source = ./waybar/style.css;
      
      ".config/waybar/scripts/random-wallpaper.sh" = {
        source = ./waybar/scripts/random-wallpaper.sh;
        executable = true;  # ensures the file has executable permissions
      };
      ".config/waybar/scripts/favorite-wallpaper.sh" = {
        source = ./waybar/scripts/favorite-wallpaper.sh;
        executable = true;
      };
    };
  };
}
