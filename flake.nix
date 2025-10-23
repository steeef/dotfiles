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
    nixpkgs.url = "github:nixos/nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code.url = "github:sadjow/claude-code-nix";
    codex-cli.url = "github:sadjow/codex-cli-nix";
    mkalias = {
      url = "github:reckenrode/mkalias";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixos-hardware,
    home-manager,
    claude-code,
    codex-cli,
    darwin,
    nur,
    nix-index-database,
    ...
  } @ inputs: let
    inherit builtins;
    username = "sprice";

    getHomeDirectory = system:
      with nixpkgs.legacyPackages.${system}.stdenv;
        if isDarwin
        then "/Users/${username}"
        else if isLinux
        then "/home/${username}"
        else "";

    getExtraModules = system:
      with nixpkgs.legacyPackages.${system}.stdenv;
        if isDarwin || isAarch64
        then [./nix/home/darwin]
        else if isLinux
        then [./nix/home/linux]
        else [];

    mkDarwinConfig = args:
      darwin.lib.darwinSystem {
        pkgs = import nixpkgs {
          inherit (args) system;
          config = {
            allowUnfree = true;
            allowInsecure = false;
            allowUnsupportedSystem = true;
            allowUnfreePredicate = pkg: true;
            allowBroken = false;
          };
        };
        specialArgs = {
          inherit (args) machine;
          inherit username;
        };
        modules = [
          ./nix/darwin
          {
            _module.args = {inherit claude-code;};
          }
          ({...}: {
            system.stateVersion = 4;
            system.primaryUser = "sprice";
          })
        ];
      };

    mkHomeConfig = args:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit (args) system;
          config = {
            allowUnfree = true;
            allowInsecure = false;
            allowUnsupportedSystem = true;
            allowUnfreePredicate = pkg: true;
            allowBroken = false;
          };

          overlays = [
            (final: prev: {
              mkalias = prev.rustPlatform.buildRustPackage rec {
                pname = "mkalias";
                version = "0.3.2";
                src = inputs.mkalias;
                cargoLock = {
                  lockFile = "${inputs.mkalias}/Cargo.lock";
                };
                buildInputs = prev.lib.optionals prev.stdenv.isDarwin [
                  prev.libiconv
                ];
                meta = {
                  description = "A simple command-line tool to create Finder aliases";
                  platforms = prev.lib.platforms.darwin;
                };
              };
            })
            (nur.overlays.default)
            (import ./nix/pkgs)
          ];
        };
        modules =
          [
            ./nix/home
            {
              home = {
                inherit username;
                homeDirectory = getHomeDirectory args.system;
                stateVersion = "23.05";
              };
            }
            nix-index-database.homeModules.nix-index
          ]
          ++ getExtraModules args.system;

        extraSpecialArgs = {
          inherit (args) machine;
          inherit inputs;
        };
      };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#nixos'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        # > Our main nixos configuration file <
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-t440s
          ./nix/nixos/configuration.nix
        ];
      };
    };

    darwinConfigurations.sp = mkDarwinConfig {
      system = "aarch64-darwin";
      machine = "sp";
    };

    darwinConfigurations.ltm-3914 = mkDarwinConfig {
      system = "aarch64-darwin";
      machine = "ltm-3914";
    };

    homeConfigurations."${username}@linux" = mkHomeConfig {
      system = "x86_64-linux";
    };

    homeConfigurations."${username}@ltm-3914" = mkHomeConfig {
      system = "aarch64-darwin";
    };

    homeConfigurations."${username}@sp" = mkHomeConfig {
      system = "aarch64-darwin";
    };
  };
}
