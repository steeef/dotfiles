{
  description = "home manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    }
  }

  outputs = { nixpkgs, home-manager, utils, ... }: {
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ]
    (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        homeConfigurations.myhome = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./home.nix
          ];
        };
        packages.homeConfigurations = self.homeConfigurations.${system};
        packages.default = self.homeConfigurations.${system}.myhome.activationPackage;
      }
    );
  }
}
