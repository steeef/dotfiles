# Claude Code configuration
#
# Requires: Clone https://github.com/steeef/claude-code-tools to ~/code/claude-code-tools
# and set CLAUDE_CODE_TOOLS_PATH environment variable
{
  inputs,
  pkgs,
  lib,
  ...
}: {
  # Install claude-powerline globally
  home.packages = with pkgs; [
    claude-powerline
  ];
  # Use official home-manager claude-code module
  programs.claude-code = {
    enable = true;
    # Use updated package from sadjow flake
    package = inputs.claude-code.packages.${pkgs.system}.default;
    # Import settings from existing JSON file
    settings = lib.importJSON ./settings.json;
  };

  # Still need activation script for memory.md since official module doesn't handle it
  home.activation.claude-memory = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Copy memory file to CLAUDE.md
    install -m 644 ${./memory.md} $HOME/.claude/CLAUDE.md
  '';
}
