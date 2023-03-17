{
  description = "home manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixpkgs, home-manager, neovim-nightly-overlay, ... }:
    let
      overlays = [
        neovim-nightly-overlay.overlay
      ];
    in
    {
      homeConfigurations = {
        macbook = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-darwin;
          modules = [
            ({
              nixpkgs.overlays = overlays;
            })
            ./home.nix
          ];
        };
        linux = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ({
              nixpkgs.overlays = overlays;
            })
            ./home.nix
          ];
        };
      };
    };
}
