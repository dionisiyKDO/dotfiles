{ lib, pkgs, zen-browser, ... }:
{
  programs.waybar.enable = true;
  home = {
    username = "dionisiy";
    homeDirectory = "/home/dionisiy";
    stateVersion = "23.11";

    
    file.".config/waybar/config".source = ./waybar/config.jsonc;
    file.".config/waybar/style.css".source = ./waybar/style.css;

    packages = with pkgs; [
      hyprpaper # wallpaper
      # dependacy for waybar
      dbus
      glib
      gtk3
      gtk-layer-shell

      btop

      pywal
      zen-browser.packages."${system}".default 
    ];
  };
}
