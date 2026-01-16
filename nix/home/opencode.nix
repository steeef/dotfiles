{
  inputs,
  config,
  pkgs,
  ...
}: {
  programs.opencode = {
    settings = {
      model = "gpt-5.1";
      theme = "catppuccin";
    };

    enable = true;
    package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
    rules = builtins.readFile ./claude/memory.md;
  };

  # Opencode-specific ripgrep config to include gitignored files in file search
  # See: https://github.com/anomalyco/opencode/issues/1535
  home.shellAliases = {
    oc = "RIPGREP_CONFIG_PATH=${config.home.homeDirectory}/.dotfiles/opencode/rgrc opencode";
  };
}
