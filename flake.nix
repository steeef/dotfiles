{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixpkgs, home-manager, darwin, neovim-nightly-overlay, ... }:
    let
      username = "sprice";

      getHomeDirectory = system: with nixpkgs.legacyPackages.${system}.stdenv;
        if isDarwin then
          "/Users/${username}"
        else if isLinux then
          "/home/${username}"
        else "";

      mkDarwinConfig = args: darwin.lib.darwinSystem {
        inherit (args) system;
        specialArgs = {
          inherit (args) machine;
        };
        modules = [
          ./darwin-configuration.nix
        ];
      };

      mkHomeConfig = args: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit (args) system;
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
          overlays = [
            neovim-nightly-overlay.overlay
          ];
        };
        modules = [
          ./nix
          {
            home = {
              inherit username;
              homeDirectory = getHomeDirectory args.system;
              stateVersion = "23.05";
            };
          }
        ];
        extraSpecialArgs = {
          inherit (args) machine;
        };
      };
    in
    {
      homeConfigurations."${username}@linux" = mkHomeConfig {
        system = "x86_64-linux";
      };

      darwinConfigurations.io = mkDarwinConfig {
        system = "x86_64-darwin";
        machine = "io";
      };

      homeConfigurations."${username}@macbook" = mkHomeConfig {
        system = "x86_64-darwin";
      };
    };
}
