# Claude Code configuration
#
# Hooks are provided by claude-hooks plugins installed via:
#   /plugin marketplace add steeef/claude-hooks
#   /plugin install <plugin>@claude-hooks
{
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Install claude-powerline globally
  home.packages = with pkgs; [
    claude-powerline
  ];

  # Claude powerline configuration
  home.file.".claude/claude-powerline.json".source = ./claude-powerline.json;

  # Use official home-manager claude-code module
  programs.claude-code = {
    enable = true;
    package = inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default;
    # Import settings from existing JSON file
    settings = lib.importJSON ./settings.json;
    # Custom skills directory
    skillsDir = ./skills;
    # Memory file for CLAUDE.md
    memory.source = ./memory.md;
  };
}
