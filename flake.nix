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
    mkalias = {
      url = "github:reckenrode/mkalias";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, darwin, neovim-nightly-overlay, ... }@inputs:
    let
      username = "sprice";

      getHomeDirectory = system: with nixpkgs.legacyPackages.${system}.stdenv;
        if isDarwin then
          "/Users/${username}"
        else if isLinux then
          "/home/${username}"
        else "";

      plugins = [ "nvim-treesitter" ];

      pluginOverlay = top: last:
        let
          buildPlug = name: top.vimUtils.buildVimPluginFrom2Nix {
            pname = name;
            version = "master";
            src = builtins.getAttr name inputs;
          };
        in
        {
          neovimPlugins = builtins.listToAttrs (map (name: { inherit name; value = buildPlug name; }) plugins);
        };

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
            neovim-nightly-overlay.overlay
            pluginOverlay
            (final: prev: { mkalias = inputs.mkalias.outputs.apps.${prev.stdenv.system}.default.program; })
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
      homeConfigurations."${username}@linux" = mkHomeConfig {
        system = "x86_64-linux";
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
        system = "x86_64-darwin";
      };
    };
}
