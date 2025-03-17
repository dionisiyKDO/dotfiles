{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    # ags.url = "github:aylur/ags";  # AGS widget
  };

  # outputs = { nixpkgs, home-manager, zen-browser, ags, ... }@inputs: # AGS widget
  outputs = { nixpkgs, home-manager, zen-browser, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in {
      homeConfigurations = {
        dionisiy = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ 
            ./home.nix 
          ];
          # extraSpecialArgs = { inherit zen-browser ags system; }; # AGS widget
          extraSpecialArgs = { inherit zen-browser system; };
        };
      };
    };
}
