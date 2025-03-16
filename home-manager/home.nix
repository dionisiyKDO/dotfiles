# { lib, pkgs, zen-browser, ags, ... }: # AGS widget
{ lib, pkgs, zen-browser, ... }:
{
  # imports = [ ags.homeManagerModules.default ];

  programs.waybar.enable = true;
  
  #   AGS widget, but it is quite complicated, so set aside for now. 
  #   Later when i'm more comfortable with Nix, I'll try to integrate 
  #   it into my NixOS and Home Manager configurations.
  #   https://github.com/Aylur/ags
  # programs.ags = {
  #   enable = true;
  #   configDir = ../ags;  # Ensure this relative path is correct
  # };

  home = {
    username = "dionisiy";
    homeDirectory = "/home/dionisiy";
    stateVersion = "23.11";

    
    file.".config/waybar/config".source = ./waybar/config.jsonc;
    file.".config/waybar/style.css".source = ./waybar/style.css;

    packages = with pkgs; [
      swww # Wallpaper manager with transitions PeepoHappy
      # hyprpaper # Wallpaper manager without transitions Sadge
      
      # dependacies for waybar
      dbus
      glib
      gtk3
      gtk-layer-shell

      btop
      killall

      pywal
      zen-browser.packages."${system}".default 

      # ags.packages.${system}.battery # AGS widget
      fzf
    ];
  };
}
