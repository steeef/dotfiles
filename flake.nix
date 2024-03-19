{
  description = "dotfiles";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mkalias = {
      url = "github:reckenrode/mkalias";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs-unstable, nixpkgs, nixos-hardware, home-manager, darwin, ... }@inputs:
    let
      inherit builtins;
      username = "sprice";

      getHomeDirectory = system: with nixpkgs.legacyPackages.${system}.stdenv;
        if isDarwin then
          "/Users/${username}"
        else if isLinux then
          "/home/${username}"
        else "";

      getExtraModules = system: with nixpkgs.legacyPackages.${system}.stdenv;
        if isDarwin then
          [ ./nix/home/darwin ]
        else if isLinux then
          [ ./nix/home/linux ]
        else [ ];

      mkDarwinConfig = args: darwin.lib.darwinSystem {
        pkgs = import nixpkgs {
          inherit (args) system;
          config = {
            allowUnfree = true;
            allowInsecure = false;
            allowUnsupportedSystem = true;
            allowUnfreePredicate = (pkg: true);
            allowBroken = false;
          };
        };
        specialArgs = {
          inherit (args) machine;
        };
        modules = [
          ./nix/darwin
        ];
      };

      mkHomeConfig = args: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit (args) system;
          config = {
            allowUnfree = true;
            allowInsecure = false;
            allowUnsupportedSystem = true;
            allowUnfreePredicate = (pkg: true);
            allowBroken = false;
          };

          overlays = [
            (final: prev: {
              mkalias = inputs.mkalias.outputs.apps.${prev.stdenv.system}.default.program;
            })
            (self: super: {
              # Import neovim from nixpkgs-unstable specifically
              neovim =
                let
                  unstablePkgs = import nixpkgs-unstable { inherit (args) system; };
                in
                unstablePkgs.neovim;
            })
            (import ./nix/pkgs)
          ];
        };
        modules = [
          ./nix/home
          {
            home = {
              inherit username;
              homeDirectory = getHomeDirectory args.system;
              stateVersion = "23.05";
            };
          }
        ] ++ getExtraModules args.system;

        extraSpecialArgs = {
          inherit (args) machine;
        };
      };
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#nixos'
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          # > Our main nixos configuration file <
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-t440s
            ./nix/nixos/configuration.nix
          ];
        };
      };

      homeConfigurations."${username}@linux" = mkHomeConfig {
        system = "x86_64-linux";
      };


      darwinConfigurations.sp = mkDarwinConfig {
        system = "aarch64-darwin";
        machine = "sp";
      };

      darwinConfigurations.io = mkDarwinConfig {
        system = "x86_64-darwin";
        machine = "io";
      };

      darwinConfigurations.ltm-7797 = mkDarwinConfig {
        system = "x86_64-darwin";
        machine = "ltm-7797";
      };

      homeConfigurations."${username}@macbook" = mkHomeConfig {
        system = builtins.currentSystem;
      };
    };
}
